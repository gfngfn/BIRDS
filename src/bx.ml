(*******************************************************)
(**
BX algorithms on Datalog programs
 *)
(********************************************************)
(*
@author: Vandang Tran
*)

open Lib
open Formulas
open Fol
open Fol_ex
open Ast2fol
open Utils


(* Take a view update put datalog program and derive the corresponding get datalog. *)
let derive_get_datalog (log : bool) (speedup : bool) (timeout : int) (inputprog : Expr.expr) : Expr.expr =
    (* verifying djsdelta property *)
    let prog = constraint2rule inputprog in
    let disdelta_thm = Ast2theorem.lean_simp_theorem_of_disjoint_delta (log) prog in
    if (not speedup) then
        (if log then print_endline "==> verifying the delta disjointness property";
        let exitcode, disdel_mess =  verify_fo_lean (log) timeout (Ast2theorem.gen_lean_code_for_theorems [disdelta_thm]) in
        if not (exitcode=0) then
            (if (exitcode = 124) then (
                if log then print_endline "Stop verifying the delta disjointness property: Timeout";
                raise (ChkErr ("\n\n" ^"Stop verifying the delta disjointness property: Timeout")))
            else
            (raise (ChkErr ("Deltas in the datalog program are not disjoint \nExit code: " ^ string_of_int exitcode ^ (if (log) then "\nError messange: "^ disdel_mess else ""))))));
    let fm = Or(sourcestability_sentence_of_stt ( log) prog, Not ( view_constraint_sentence_of_stt log prog)) in
    (* let fm = sourcestability_sentence_of_stt ( log) prog in *)
    let view_name = Expr.get_rterm_predname (Expr.get_schema_rterm (get_view prog)) in
    let view_vars = List.map (fun x -> Expr.string_of_var x) @@ Expr.get_rterm_varlist (Expr.get_schema_rterm (get_view prog)) in
    if log then (
    print_endline "===> solving sourcestability & constraints to check the view existence";
    print_endline @@ "FO sentence of the original sourcestability & constraints: " ^(lean_string_of_fol_formula fm);
    );
    let phi, lst = ranf2lvnf view_name fm in
    (* we do not need vars any more because it must be all free variables in vfol and phi_i *)
    let lst2 = List.map (fun (vars, vfol, phi_i) ->
    match vfol with
        Atom(R(view_name,lst)) | Not(Atom(R(view_name,lst))) -> let subfn = fpf (List.map (fun x -> Fol_ex.string_of_term 0 x) lst) (List.map (fun x -> Fol.Var x) view_vars) in
        (subst subfn vfol, subst subfn phi_i)
        | _ -> (vfol, phi_i)
    ) lst in
    if log then (
    print_endline "______constraints from the view-predicate normal form_______";
    print_endline @@ "phi: " ^(lean_string_of_fol_formula phi);
    List.iter (fun (vfol, phi_i) ->
    print_endline @@ "false <=> : " ^ (lean_string_of_fol_formula ((vfol))) ;
    print_endline @@ ", " ^ (lean_string_of_fol_formula ((phi_i))) ^"\n";
    ) lst2;
    );

    (* contruct upper bound FO formula of view *)
    let view_upper_fol = List.fold_left (fun fm (vfol, phi_i) ->
    match vfol with
        Formulas.Atom(R(view_name,lst)) -> let ex_vars = subtract (fv phi_i) view_vars in And(fm, Not(itlist mk_exists ex_vars phi_i) )
        | _ -> fm
    ) True lst2 in
    if log then print_endline @@ "Upper bound of the view: "^ (lean_string_of_fol_formula ((view_upper_fol)));
    (* contruct lower bound FO formula of view *)
    let view_lower_fol = List.fold_left (fun fm (vfol, phi_i) ->
    match vfol with
        | Formulas.Not(Formulas.Atom(R(view_name,lst)))  -> let ex_vars = subtract (fv phi_i) view_vars in Or(fm, itlist mk_exists ex_vars phi_i )
        | _ -> fm
    ) False lst2 in
    if log then print_endline @@ "Lower bound of the view: " ^ (lean_string_of_fol_formula ((view_lower_fol)));

    (* make an equivalence sentence of checking whether lower FOL of view implies upper FOL of view *)
    let sentence_of_view_existence = generalize (Imp(view_lower_fol, view_upper_fol)) in
    if log then (print_endline @@ "FO sentence of the view existence : " ^ (lean_string_of_fol_formula ((sentence_of_view_existence)));
    print_endline "_______________________________________\n");
    if log then (print_endline "==> generating a theorem for the view existence property";) else ();

    (* checking the FO sentence of the existence of a view *)
    let theorem_of_view_existence = Ast2theorem.lean_theorem_of_view_existence log prog sentence_of_view_existence phi in
    let lean_code_view_existence = Ast2theorem.gen_lean_code_for_theorems [theorem_of_view_existence] in

    if (not speedup) then
        (if log then print_endline "==> verifying the view existence property";
        let exitcode, message =  verify_fo_lean (log) timeout lean_code_view_existence in
        if not (exitcode=0) then
            (if (exitcode = 124) then (
                if log then print_endline "Stop verifying the view existence property: Timeout";
                raise (ChkErr ("\n\n" ^"Stop verifying the view existence property: Timeout")))
            else
                (raise (ChkErr ("Fail to construct a view definition, the program may not be well-behaved or not be in LVGN-Datalog \nExit code: " ^ string_of_int exitcode ^ "\nHint: Write an expected view definition in the Datalog program" ^ (if (log) then "\nError messange: "^ message else ""))))));
    (* choose the lower bound as a FO formula of the view *)
    let view_fo = view_lower_fol in
    let refined_view_fo = remove_trivial (ranf (Skolem.simplify (normalize_comparison view_fo))) in
    if log then print_endline @@ "FO formula of the view: " ^ Fol_ex.lean_string_of_fol_formula refined_view_fo ;
    if (refined_view_fo = False) then raise (ChkErr "Fail to construct the view definition, be sure there is no self-join or projection on the view in the Datalog program");
    let raw_get_ast = view_fol2datalog log (get_view prog) prog.sources view_vars (refined_view_fo ) in
    let get_ast = Ast2fol.optimize_query_datalog log {raw_get_ast with query = Some (Expr.get_schema_rterm (get_view prog))} in
    if log then (
        print_endline "______get datalog program:_______";
        print_endline (Expr.string_of_prog get_ast);
        print_endline "_________________________________";
    );
    (* verify the putget property *)
    (* let get_rules exp = fst (Rule_preprocess.seperate_rules exp) in  *)
    let bi_prog = Expr.add_rules get_ast.rules inputprog in
    let putget_thm = (Ast2theorem.lean_simp_theorem_of_putget (log) (constraint2rule bi_prog)) in
    let lean_code_putget = Ast2theorem.gen_lean_code_for_theorems [ putget_thm ] in

    if (not speedup) then (
        if log then print_endline "==> Verifying the putget property";
        let exitcode, message = verify_fo_lean (log) (timeout) lean_code_putget in
        if not (exitcode=0) then
            if (exitcode = 124) then (
                if log then print_endline "Stop verifying the putget property: Timeout";
                raise (ChkErr ("Stop verifying the putget property: Timeout")))
            else
            (raise (ChkErr ("Property putget is not validated \nExit code: " ^ string_of_int exitcode
            ^ (if (log) then "\nError messange: "^ message else ""))));
    );

    if speedup then (
        if log then print_endline "==> Verifying all properties of a putback program";
        let lean_code_all = Ast2theorem.gen_lean_code_for_theorems [ disdelta_thm; theorem_of_view_existence; putget_thm ] in
        let exitcode, message = verify_fo_lean (log) (timeout) lean_code_all in
        if not (exitcode=0) then
            if (exitcode = 124) then (
                if log then print_endline "Stop verifying all properties of a putback program: Timeout";
                raise (ChkErr ("Stop verifying all properties of a putback program: Timeout")))
            else
            (raise (ChkErr ("Well-behavedness is not validated \nExit code: " ^ string_of_int exitcode
            ^ (if (log) then "\nError messange: "^ message else ""))));
    );
    print_endline @@ "-- Program is validated and the view definition is derived --";
    get_ast
