%created by Luke Hawkins
%To schedule employees for a business and guratee employees rights are adhired to


:- use_module(library(clpfd)).


mySwap(Goal, B,A):-call(Goal, A, B).

mySum(Eq, List, Num):- sum(List,Eq,Num).

are_bools(Row):-
    Row ins 0..1.

min_week([[0,1,2,3,3,2,1,0], [0,1,2,3,3,2,1,0], [0,1,2,3,3,2,1,0], [0,1,2,3,3,2,1,0],
 [0,1,2,3,3,2,1,0], [0,1,2,3,3,2,1,0], [0,1,2,3,3,2,1,0]]).

max_week([[0,2,2,3,3,3,2,1],[0,2,2,3,3,3,2,1],[0,2,2,3,3,3,2,1],[0,2,2,3,3,3,2,1],
 [0,2,2,3,3,3,2,1],[0,2,2,3,3,3,2,1],[0,2,2,3,3,3,2,1]]).


%amount of work required by a business each 15 minutes
% EmpPerUnit is hour many Employees are needed at min
% [0,0,0,1,2,3,4,1,3]
%
% EmpsSchedule is when an employee is working
% [[0, 1, 0, 1], [0,1,-0 ,1]]



schedule_week(Min, Max, Schedules):-
    maplist(is_valid_ScheduleWeek, Schedules),
    maplist(mySwap(length, Len), Schedules),
    length(Min, Len),
    length(Max, Len),
    maplist(emp_full_time_week, Schedules),
    transpose(Schedules, Days),
    maplist(schedule_day, Min, Max, Days),
    flatten(Schedules, DaysFlat),
    flatten(DaysFlat, HoursFlat),
    label(HoursFlat).

schedule_day(Min, Max, Schedules):-
    maplist(is_valid_Schedule, Schedules),
    maplist(mySwap(length, Len), Schedules),
    length(Min, Len),
    length(Max, Len),
    maplist(emp_full_time_day, Schedules),
    transpose(Schedules, EmpsScheduleHour_Emp),
    maplist(mySum(#>=), EmpsScheduleHour_Emp, Min),
    maplist(mySum(#=<), EmpsScheduleHour_Emp, Max).




%empRights(Emp):-
%    (Emp = full_time ->
%
%    ).

second(Func, _-B):- 
    call(Func, B).


zip([],[],[]).
zip([A-B|Zs], [A|As], [B|Bs]):-
    zip(Zs,As,Bs).

minSum(Min, List):-
    sum(List, #>=, Min).

maxSum(Max, List):-
    sum(List, #=<, Max).

minOrNunSum(Min, List):-
    minSum(Min, List);
    sum(List, #=, 0).

or0(Func, List):-
    call(Func, List);
    sum(List, #=, 0).

emp_full_time_week(Week):-
    flatten(Week, Weeks_Comb),
    minSum(3, Weeks_Comb).

emp_full_time_day(Day):-
    
    (minSum(3, Day);
    sum(Day, #=, 0)).

    

is_valid_DateTime(Y-W):-
    W in 0..56,
    Y in 2000..2100.

is_valid_Schedule(Schedule):-
    length(Schedule, 8),
    are_bools(Schedule).
    

is_valid_ScheduleWeek(Schedule):-
    length(Schedule, 7),
    maplist(is_valid_Schedule, Schedule).
    

is_valid_DateTime_Sched(DateTime-Schedule):-
    is_valid_DateTime(DateTime),
    is_valid_ScheduleWeek(Schedule).
    
%Schedule is an array of Year and week, with an array of week shift
empSched(_, Schedule):-
    maplist(is_valid_DateTime_Sched, Schedule),
    Schedule \= [].




empHourlyPay(0, 10).
empHourlyPay(1, 14).
empHourlyPay(2, 22).

empType(0, full_time).
empType(1, part_time).
empType(2, casual).



    
    


