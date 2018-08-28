/*_____get datalog program_______
?- all_vehicles(COMPANY_ID,VEHICLE_ID,CURRENT_AREA,SEAT_COUNT,REQUEST_ID,PICKUP_LOCATION,DROPOFF_LOCATION).

all_vehicles(ALL_VEHICLES_A7_COMPANY_ID,ALL_VEHICLES_A7_VEHICLE_ID,ALL_VEHICLES_A7_CURRENT_AREA,ALL_VEHICLES_A7_SEAT_COUNT,ALL_VEHICLES_A7_REQUEST_ID,ALL_VEHICLES_A7_PICKUP_LOCATION,ALL_VEHICLES_A7_DROPOFF_LOCATION) :- all_vehicles_med(ALL_VEHICLES_A7_COMPANY_ID,ALL_VEHICLES_A7_VEHICLE_ID,ALL_VEHICLES_A7_CURRENT_AREA,ALL_VEHICLES_A7_SEAT_COUNT,ALL_VEHICLES_A7_REQUEST_ID,ALL_VEHICLES_A7_PICKUP_LOCATION,ALL_VEHICLES_A7_DROPOFF_LOCATION) , not __dummy__delta__insert__peer2_public(ALL_VEHICLES_A7_VEHICLE_ID,ALL_VEHICLES_A7_CURRENT_AREA,ALL_VEHICLES_A7_SEAT_COUNT,ALL_VEHICLES_A7_REQUEST_ID,ALL_VEHICLES_A7_PICKUP_LOCATION,ALL_VEHICLES_A7_DROPOFF_LOCATION) , not __dummy__delta__insert__peer1_public(ALL_VEHICLES_A7_VEHICLE_ID,ALL_VEHICLES_A7_CURRENT_AREA,ALL_VEHICLES_A7_SEAT_COUNT,ALL_VEHICLES_A7_REQUEST_ID,ALL_VEHICLES_A7_PICKUP_LOCATION,ALL_VEHICLES_A7_DROPOFF_LOCATION).

__dummy__delta__insert__peer1_public(V,A,S,R,P,D) :- all_vehicles_med(C,V,A,S,R,P,D) , C = 1 , not peer1_public(V,A,S,R,P,D).

all_vehicles_med(C,V,A,S,R,P,D) :- peer1_public(V,A,S,R,P,D) , C = 1.

__dummy__delta__insert__peer2_public(V,A,S,R,P,D) :- all_vehicles_med(C,V,A,S,R,P,D) , C = 2 , not peer2_public(V,A,S,R,P,D).

all_vehicles_med(C,V,A,S,R,P,D) :- peer2_public(V,A,S,R,P,D) , C = 2.

______________*/

CREATE OR REPLACE VIEW public.all_vehicles AS 
SELECT __dummy__.col0 AS COMPANY_ID,__dummy__.col1 AS VEHICLE_ID,__dummy__.col2 AS CURRENT_AREA,__dummy__.col3 AS SEAT_COUNT,__dummy__.col4 AS REQUEST_ID,__dummy__.col5 AS PICKUP_LOCATION,__dummy__.col6 AS DROPOFF_LOCATION 
FROM (SELECT all_vehicles_a7_0.col0 AS col0, all_vehicles_a7_0.col1 AS col1, all_vehicles_a7_0.col2 AS col2, all_vehicles_a7_0.col3 AS col3, all_vehicles_a7_0.col4 AS col4, all_vehicles_a7_0.col5 AS col5, all_vehicles_a7_0.col6 AS col6 
FROM (SELECT all_vehicles_med_a7_0.col0 AS col0, all_vehicles_med_a7_0.col1 AS col1, all_vehicles_med_a7_0.col2 AS col2, all_vehicles_med_a7_0.col3 AS col3, all_vehicles_med_a7_0.col4 AS col4, all_vehicles_med_a7_0.col5 AS col5, all_vehicles_med_a7_0.col6 AS col6 
FROM (SELECT 1 AS col0, peer1_public_a6_0.VEHICLE_ID AS col1, peer1_public_a6_0.CURRENT_AREA AS col2, peer1_public_a6_0.SEAT_COUNT AS col3, peer1_public_a6_0.REQUEST_ID AS col4, peer1_public_a6_0.PICKUP_LOCATION AS col5, peer1_public_a6_0.DROPOFF_LOCATION AS col6 
FROM public.peer1_public AS peer1_public_a6_0   UNION ALL SELECT 2 AS col0, peer2_public_a6_0.VEHICLE_ID AS col1, peer2_public_a6_0.CURRENT_AREA AS col2, peer2_public_a6_0.SEAT_COUNT AS col3, peer2_public_a6_0.REQUEST_ID AS col4, peer2_public_a6_0.PICKUP_LOCATION AS col5, peer2_public_a6_0.DROPOFF_LOCATION AS col6 
FROM public.peer2_public AS peer2_public_a6_0  ) AS all_vehicles_med_a7_0 
WHERE NOT EXISTS ( SELECT * 
FROM (SELECT all_vehicles_med_a7_0.col1 AS col0, all_vehicles_med_a7_0.col2 AS col1, all_vehicles_med_a7_0.col3 AS col2, all_vehicles_med_a7_0.col4 AS col3, all_vehicles_med_a7_0.col5 AS col4, all_vehicles_med_a7_0.col6 AS col5 
FROM (SELECT 1 AS col0, peer1_public_a6_0.VEHICLE_ID AS col1, peer1_public_a6_0.CURRENT_AREA AS col2, peer1_public_a6_0.SEAT_COUNT AS col3, peer1_public_a6_0.REQUEST_ID AS col4, peer1_public_a6_0.PICKUP_LOCATION AS col5, peer1_public_a6_0.DROPOFF_LOCATION AS col6 
FROM public.peer1_public AS peer1_public_a6_0   UNION ALL SELECT 2 AS col0, peer2_public_a6_0.VEHICLE_ID AS col1, peer2_public_a6_0.CURRENT_AREA AS col2, peer2_public_a6_0.SEAT_COUNT AS col3, peer2_public_a6_0.REQUEST_ID AS col4, peer2_public_a6_0.PICKUP_LOCATION AS col5, peer2_public_a6_0.DROPOFF_LOCATION AS col6 
FROM public.peer2_public AS peer2_public_a6_0  ) AS all_vehicles_med_a7_0 
WHERE all_vehicles_med_a7_0.col0 = 2 AND NOT EXISTS ( SELECT * 
FROM public.peer2_public AS peer2_public_a6 
WHERE peer2_public_a6.DROPOFF_LOCATION IS NOT DISTINCT FROM all_vehicles_med_a7_0.col6 AND peer2_public_a6.PICKUP_LOCATION IS NOT DISTINCT FROM all_vehicles_med_a7_0.col5 AND peer2_public_a6.REQUEST_ID IS NOT DISTINCT FROM all_vehicles_med_a7_0.col4 AND peer2_public_a6.SEAT_COUNT IS NOT DISTINCT FROM all_vehicles_med_a7_0.col3 AND peer2_public_a6.CURRENT_AREA IS NOT DISTINCT FROM all_vehicles_med_a7_0.col2 AND peer2_public_a6.VEHICLE_ID IS NOT DISTINCT FROM all_vehicles_med_a7_0.col1 ) ) AS __dummy__delta__insert__peer2_public_a6 
WHERE __dummy__delta__insert__peer2_public_a6.col5 IS NOT DISTINCT FROM all_vehicles_med_a7_0.col6 AND __dummy__delta__insert__peer2_public_a6.col4 IS NOT DISTINCT FROM all_vehicles_med_a7_0.col5 AND __dummy__delta__insert__peer2_public_a6.col3 IS NOT DISTINCT FROM all_vehicles_med_a7_0.col4 AND __dummy__delta__insert__peer2_public_a6.col2 IS NOT DISTINCT FROM all_vehicles_med_a7_0.col3 AND __dummy__delta__insert__peer2_public_a6.col1 IS NOT DISTINCT FROM all_vehicles_med_a7_0.col2 AND __dummy__delta__insert__peer2_public_a6.col0 IS NOT DISTINCT FROM all_vehicles_med_a7_0.col1 ) AND NOT EXISTS ( SELECT * 
FROM (SELECT all_vehicles_med_a7_0.col1 AS col0, all_vehicles_med_a7_0.col2 AS col1, all_vehicles_med_a7_0.col3 AS col2, all_vehicles_med_a7_0.col4 AS col3, all_vehicles_med_a7_0.col5 AS col4, all_vehicles_med_a7_0.col6 AS col5 
FROM (SELECT 1 AS col0, peer1_public_a6_0.VEHICLE_ID AS col1, peer1_public_a6_0.CURRENT_AREA AS col2, peer1_public_a6_0.SEAT_COUNT AS col3, peer1_public_a6_0.REQUEST_ID AS col4, peer1_public_a6_0.PICKUP_LOCATION AS col5, peer1_public_a6_0.DROPOFF_LOCATION AS col6 
FROM public.peer1_public AS peer1_public_a6_0   UNION ALL SELECT 2 AS col0, peer2_public_a6_0.VEHICLE_ID AS col1, peer2_public_a6_0.CURRENT_AREA AS col2, peer2_public_a6_0.SEAT_COUNT AS col3, peer2_public_a6_0.REQUEST_ID AS col4, peer2_public_a6_0.PICKUP_LOCATION AS col5, peer2_public_a6_0.DROPOFF_LOCATION AS col6 
FROM public.peer2_public AS peer2_public_a6_0  ) AS all_vehicles_med_a7_0 
WHERE all_vehicles_med_a7_0.col0 = 1 AND NOT EXISTS ( SELECT * 
FROM public.peer1_public AS peer1_public_a6 
WHERE peer1_public_a6.DROPOFF_LOCATION IS NOT DISTINCT FROM all_vehicles_med_a7_0.col6 AND peer1_public_a6.PICKUP_LOCATION IS NOT DISTINCT FROM all_vehicles_med_a7_0.col5 AND peer1_public_a6.REQUEST_ID IS NOT DISTINCT FROM all_vehicles_med_a7_0.col4 AND peer1_public_a6.SEAT_COUNT IS NOT DISTINCT FROM all_vehicles_med_a7_0.col3 AND peer1_public_a6.CURRENT_AREA IS NOT DISTINCT FROM all_vehicles_med_a7_0.col2 AND peer1_public_a6.VEHICLE_ID IS NOT DISTINCT FROM all_vehicles_med_a7_0.col1 ) ) AS __dummy__delta__insert__peer1_public_a6 
WHERE __dummy__delta__insert__peer1_public_a6.col5 IS NOT DISTINCT FROM all_vehicles_med_a7_0.col6 AND __dummy__delta__insert__peer1_public_a6.col4 IS NOT DISTINCT FROM all_vehicles_med_a7_0.col5 AND __dummy__delta__insert__peer1_public_a6.col3 IS NOT DISTINCT FROM all_vehicles_med_a7_0.col4 AND __dummy__delta__insert__peer1_public_a6.col2 IS NOT DISTINCT FROM all_vehicles_med_a7_0.col3 AND __dummy__delta__insert__peer1_public_a6.col1 IS NOT DISTINCT FROM all_vehicles_med_a7_0.col2 AND __dummy__delta__insert__peer1_public_a6.col0 IS NOT DISTINCT FROM all_vehicles_med_a7_0.col1 ) ) AS all_vehicles_a7_0  ) AS __dummy__;

CREATE OR REPLACE FUNCTION public.all_vehicles_procedure()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  temprec record;
  BEGIN
    CREATE TEMPORARY TABLE __temp__all_vehicles WITH OIDS ON COMMIT DROP AS SELECT * FROM public.all_vehicles;
    IF TG_OP = 'INSERT' THEN
      INSERT INTO __temp__all_vehicles SELECT (NEW).*; 
    ELSIF TG_OP = 'UPDATE' THEN
      DELETE FROM __temp__all_vehicles WHERE (COMPANY_ID,VEHICLE_ID,CURRENT_AREA,SEAT_COUNT,REQUEST_ID,PICKUP_LOCATION,DROPOFF_LOCATION) = OLD;
      INSERT INTO __temp__all_vehicles SELECT (NEW).*; 
    ELSIF TG_OP = 'DELETE' THEN
      DELETE FROM __temp__all_vehicles WHERE (COMPANY_ID,VEHICLE_ID,CURRENT_AREA,SEAT_COUNT,REQUEST_ID,PICKUP_LOCATION,DROPOFF_LOCATION) = OLD;
    END IF;
    CREATE TEMPORARY TABLE __dummy__delta__delete__peer1_public WITH OIDS ON COMMIT DROP AS SELECT __dummy__delta__delete__peer1_public_a6_0.col0 AS col0, __dummy__delta__delete__peer1_public_a6_0.col1 AS col1, __dummy__delta__delete__peer1_public_a6_0.col2 AS col2, __dummy__delta__delete__peer1_public_a6_0.col3 AS col3, __dummy__delta__delete__peer1_public_a6_0.col4 AS col4, __dummy__delta__delete__peer1_public_a6_0.col5 AS col5 
FROM (SELECT peer1_public_a6_0.VEHICLE_ID AS col0, peer1_public_a6_0.CURRENT_AREA AS col1, peer1_public_a6_0.SEAT_COUNT AS col2, peer1_public_a6_0.REQUEST_ID AS col3, peer1_public_a6_0.PICKUP_LOCATION AS col4, peer1_public_a6_0.DROPOFF_LOCATION AS col5 
FROM public.peer1_public AS peer1_public_a6_0 
WHERE NOT EXISTS ( SELECT * 
FROM (SELECT __temp__all_vehicles_a7_0.COMPANY_ID AS col0, __temp__all_vehicles_a7_0.VEHICLE_ID AS col1, __temp__all_vehicles_a7_0.CURRENT_AREA AS col2, __temp__all_vehicles_a7_0.SEAT_COUNT AS col3, __temp__all_vehicles_a7_0.REQUEST_ID AS col4, __temp__all_vehicles_a7_0.PICKUP_LOCATION AS col5, __temp__all_vehicles_a7_0.DROPOFF_LOCATION AS col6 
FROM __temp__all_vehicles AS __temp__all_vehicles_a7_0  ) AS all_vehicles_a7 
WHERE all_vehicles_a7.col6 IS NOT DISTINCT FROM peer1_public_a6_0.DROPOFF_LOCATION AND all_vehicles_a7.col5 IS NOT DISTINCT FROM peer1_public_a6_0.PICKUP_LOCATION AND all_vehicles_a7.col4 IS NOT DISTINCT FROM peer1_public_a6_0.REQUEST_ID AND all_vehicles_a7.col3 IS NOT DISTINCT FROM peer1_public_a6_0.SEAT_COUNT AND all_vehicles_a7.col2 IS NOT DISTINCT FROM peer1_public_a6_0.CURRENT_AREA AND all_vehicles_a7.col1 IS NOT DISTINCT FROM peer1_public_a6_0.VEHICLE_ID AND all_vehicles_a7.col0 IS NOT DISTINCT FROM 1 ) ) AS __dummy__delta__delete__peer1_public_a6_0  ;

CREATE TEMPORARY TABLE __dummy__delta__delete__peer2_public WITH OIDS ON COMMIT DROP AS SELECT __dummy__delta__delete__peer2_public_a6_0.col0 AS col0, __dummy__delta__delete__peer2_public_a6_0.col1 AS col1, __dummy__delta__delete__peer2_public_a6_0.col2 AS col2, __dummy__delta__delete__peer2_public_a6_0.col3 AS col3, __dummy__delta__delete__peer2_public_a6_0.col4 AS col4, __dummy__delta__delete__peer2_public_a6_0.col5 AS col5 
FROM (SELECT peer2_public_a6_0.VEHICLE_ID AS col0, peer2_public_a6_0.CURRENT_AREA AS col1, peer2_public_a6_0.SEAT_COUNT AS col2, peer2_public_a6_0.REQUEST_ID AS col3, peer2_public_a6_0.PICKUP_LOCATION AS col4, peer2_public_a6_0.DROPOFF_LOCATION AS col5 
FROM public.peer2_public AS peer2_public_a6_0 
WHERE NOT EXISTS ( SELECT * 
FROM (SELECT __temp__all_vehicles_a7_0.COMPANY_ID AS col0, __temp__all_vehicles_a7_0.VEHICLE_ID AS col1, __temp__all_vehicles_a7_0.CURRENT_AREA AS col2, __temp__all_vehicles_a7_0.SEAT_COUNT AS col3, __temp__all_vehicles_a7_0.REQUEST_ID AS col4, __temp__all_vehicles_a7_0.PICKUP_LOCATION AS col5, __temp__all_vehicles_a7_0.DROPOFF_LOCATION AS col6 
FROM __temp__all_vehicles AS __temp__all_vehicles_a7_0  ) AS all_vehicles_a7 
WHERE all_vehicles_a7.col6 IS NOT DISTINCT FROM peer2_public_a6_0.DROPOFF_LOCATION AND all_vehicles_a7.col5 IS NOT DISTINCT FROM peer2_public_a6_0.PICKUP_LOCATION AND all_vehicles_a7.col4 IS NOT DISTINCT FROM peer2_public_a6_0.REQUEST_ID AND all_vehicles_a7.col3 IS NOT DISTINCT FROM peer2_public_a6_0.SEAT_COUNT AND all_vehicles_a7.col2 IS NOT DISTINCT FROM peer2_public_a6_0.CURRENT_AREA AND all_vehicles_a7.col1 IS NOT DISTINCT FROM peer2_public_a6_0.VEHICLE_ID AND all_vehicles_a7.col0 IS NOT DISTINCT FROM 2 ) ) AS __dummy__delta__delete__peer2_public_a6_0  ;

CREATE TEMPORARY TABLE __dummy__delta__insert__peer1_public WITH OIDS ON COMMIT DROP AS SELECT __dummy__delta__insert__peer1_public_a6_0.col0 AS col0, __dummy__delta__insert__peer1_public_a6_0.col1 AS col1, __dummy__delta__insert__peer1_public_a6_0.col2 AS col2, __dummy__delta__insert__peer1_public_a6_0.col3 AS col3, __dummy__delta__insert__peer1_public_a6_0.col4 AS col4, __dummy__delta__insert__peer1_public_a6_0.col5 AS col5 
FROM (SELECT all_vehicles_a7_0.col1 AS col0, all_vehicles_a7_0.col2 AS col1, all_vehicles_a7_0.col3 AS col2, all_vehicles_a7_0.col4 AS col3, all_vehicles_a7_0.col5 AS col4, all_vehicles_a7_0.col6 AS col5 
FROM (SELECT __temp__all_vehicles_a7_0.COMPANY_ID AS col0, __temp__all_vehicles_a7_0.VEHICLE_ID AS col1, __temp__all_vehicles_a7_0.CURRENT_AREA AS col2, __temp__all_vehicles_a7_0.SEAT_COUNT AS col3, __temp__all_vehicles_a7_0.REQUEST_ID AS col4, __temp__all_vehicles_a7_0.PICKUP_LOCATION AS col5, __temp__all_vehicles_a7_0.DROPOFF_LOCATION AS col6 
FROM __temp__all_vehicles AS __temp__all_vehicles_a7_0  ) AS all_vehicles_a7_0 
WHERE all_vehicles_a7_0.col0 = 1 AND NOT EXISTS ( SELECT * 
FROM public.peer1_public AS peer1_public_a6 
WHERE peer1_public_a6.DROPOFF_LOCATION IS NOT DISTINCT FROM all_vehicles_a7_0.col6 AND peer1_public_a6.PICKUP_LOCATION IS NOT DISTINCT FROM all_vehicles_a7_0.col5 AND peer1_public_a6.REQUEST_ID IS NOT DISTINCT FROM all_vehicles_a7_0.col4 AND peer1_public_a6.SEAT_COUNT IS NOT DISTINCT FROM all_vehicles_a7_0.col3 AND peer1_public_a6.CURRENT_AREA IS NOT DISTINCT FROM all_vehicles_a7_0.col2 AND peer1_public_a6.VEHICLE_ID IS NOT DISTINCT FROM all_vehicles_a7_0.col1 ) ) AS __dummy__delta__insert__peer1_public_a6_0  ;

CREATE TEMPORARY TABLE __dummy__delta__insert__peer2_public WITH OIDS ON COMMIT DROP AS SELECT __dummy__delta__insert__peer2_public_a6_0.col0 AS col0, __dummy__delta__insert__peer2_public_a6_0.col1 AS col1, __dummy__delta__insert__peer2_public_a6_0.col2 AS col2, __dummy__delta__insert__peer2_public_a6_0.col3 AS col3, __dummy__delta__insert__peer2_public_a6_0.col4 AS col4, __dummy__delta__insert__peer2_public_a6_0.col5 AS col5 
FROM (SELECT all_vehicles_a7_0.col1 AS col0, all_vehicles_a7_0.col2 AS col1, all_vehicles_a7_0.col3 AS col2, all_vehicles_a7_0.col4 AS col3, all_vehicles_a7_0.col5 AS col4, all_vehicles_a7_0.col6 AS col5 
FROM (SELECT __temp__all_vehicles_a7_0.COMPANY_ID AS col0, __temp__all_vehicles_a7_0.VEHICLE_ID AS col1, __temp__all_vehicles_a7_0.CURRENT_AREA AS col2, __temp__all_vehicles_a7_0.SEAT_COUNT AS col3, __temp__all_vehicles_a7_0.REQUEST_ID AS col4, __temp__all_vehicles_a7_0.PICKUP_LOCATION AS col5, __temp__all_vehicles_a7_0.DROPOFF_LOCATION AS col6 
FROM __temp__all_vehicles AS __temp__all_vehicles_a7_0  ) AS all_vehicles_a7_0 
WHERE all_vehicles_a7_0.col0 = 2 AND NOT EXISTS ( SELECT * 
FROM public.peer2_public AS peer2_public_a6 
WHERE peer2_public_a6.DROPOFF_LOCATION IS NOT DISTINCT FROM all_vehicles_a7_0.col6 AND peer2_public_a6.PICKUP_LOCATION IS NOT DISTINCT FROM all_vehicles_a7_0.col5 AND peer2_public_a6.REQUEST_ID IS NOT DISTINCT FROM all_vehicles_a7_0.col4 AND peer2_public_a6.SEAT_COUNT IS NOT DISTINCT FROM all_vehicles_a7_0.col3 AND peer2_public_a6.CURRENT_AREA IS NOT DISTINCT FROM all_vehicles_a7_0.col2 AND peer2_public_a6.VEHICLE_ID IS NOT DISTINCT FROM all_vehicles_a7_0.col1 ) ) AS __dummy__delta__insert__peer2_public_a6_0  ; 

 FOR temprec IN ( SELECT * FROM __dummy__delta__delete__peer1_public) LOOP 
        DELETE FROM public.peer1_public WHERE (VEHICLE_ID,CURRENT_AREA,SEAT_COUNT,REQUEST_ID,PICKUP_LOCATION,DROPOFF_LOCATION) IS NOT DISTINCT FROM  (temprec.col0,temprec.col1,temprec.col2,temprec.col3,temprec.col4,temprec.col5);
        END LOOP;

 FOR temprec IN ( SELECT * FROM __dummy__delta__delete__peer2_public) LOOP 
        DELETE FROM public.peer2_public WHERE (VEHICLE_ID,CURRENT_AREA,SEAT_COUNT,REQUEST_ID,PICKUP_LOCATION,DROPOFF_LOCATION) IS NOT DISTINCT FROM  (temprec.col0,temprec.col1,temprec.col2,temprec.col3,temprec.col4,temprec.col5);
        END LOOP;

INSERT INTO public.peer1_public SELECT * FROM __dummy__delta__insert__peer1_public;

INSERT INTO public.peer2_public SELECT * FROM __dummy__delta__insert__peer2_public;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to base tables of public.all_vehicles';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.all_vehicles ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
  
$$;
DROP TRIGGER IF EXISTS all_vehicles_trigger ON public.all_vehicles;
CREATE TRIGGER all_vehicles_trigger
    INSTEAD OF INSERT OR UPDATE OR DELETE ON
      public.all_vehicles FOR EACH ROW EXECUTE PROCEDURE public.all_vehicles_procedure();

