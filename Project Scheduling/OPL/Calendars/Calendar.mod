
using CP;
 
/********
 * Data *
 ********/
 
tuple Task {
  key int id;
  string  name;
  int     ptMin;
};

{ Task } Tasks = ...;

tuple hierarchy_data {  // hierarchy data
  int taskId;
  int parentId;
};

{ hierarchy_data } Hierarchy = ...;
{ int } Parents = { p.parentId | p in Hierarchy };


tuple Precedence {
  int    beforeId;
  int    afterId;
  string type;
  int    delay;
};

{ Precedence } Precedences = ...;

tuple Worker {
  key int id;
  string  name;
  float   fixedCost;
  float   varCost;
};

{ Worker } Workers = ...;

tuple Skill {
  key int id;
  string  name;
};

{ Skill } Skills = ...;

tuple Proficiency {
  int workerId;
  int skillId;
  int level;
};
  
{ Proficiency } Proficiencies = ...;

tuple Requirement {
  key int id;
  int     taskId;
};

{ Requirement } Requirements = ...;

tuple RequiredSkill {
  int reqId;
  int skillId;
  int levelMin;
  int levelMax;
};

{ RequiredSkill } RequiredSkills = ...;

{ int } PossibleWorkers[r in Requirements] = 
   { p.workerId | p in Proficiencies, n in RequiredSkills : 
     (n.reqId==r.id) && 
     (p.skillId==n.skillId) && 
     (n.levelMin <= p.level) && 
     (p.level <= n.levelMax) };

tuple Alloc {
  int reqId;
  int workerId;
  int pt;
};

{ Alloc } Allocations = { <r.id, i, t.ptMin> | r in Requirements, t in Tasks, i in PossibleWorkers[r] : t.id==r.taskId };

tuple WorkerBreak {
  int workerId;
  int start; 
  int end;
};

{ WorkerBreak } WorkerBreaks = ...;

// KPIs
float MakespanWeight     = ...;
float FixedWeight        = ...;
float VariableWeight = ...;

int MaxInterval = 10000001;

tuple Step {
  int value;
  key int time;
};
sorted {Step} Steps[w in Workers] =
   { <100, b.start> | b in WorkerBreaks : b.workerId==w.id } union 
   { <0,   b.end>   | b in WorkerBreaks : b.workerId==w.id };
   
stepFunction breaks[w in Workers] = stepwise (s in Steps[w]) { s.value -> s.time; 100 };

/**********************
 * Decision variables *
 **********************/
 
dvar interval task[t in Tasks] size t.ptMin..MaxInterval;
dvar interval alts[a in Allocations] optional size a.pt..MaxInterval intensity breaks[<a.workerId>];
dvar interval workerSpan[w in Workers] optional;

/************************
 * Decision expressions *
 ************************/
 
dexpr int makespan = max(t in Tasks) endOf(task[t]);
dexpr int workerTimeSpent[w in Workers] = sum(a in Allocations: a.workerId==w.id) sizeOf(alts[a],0);
dexpr float workersFixedCost = sum(w in Workers) w.fixedCost * presenceOf(workerSpan[w]); 
dexpr float workersVariableCost = sum(w in Workers) w.varCost*workerTimeSpent[w];

/*************
 * Objective *
 *************/
 
minimize MakespanWeight * makespan 
         + FixedWeight * workersFixedCost 
         + VariableWeight * workersVariableCost;

/***************
 * Constraints *
 ***************/
 
subject to {   
  // Work breakdown structure
  forall (t in Tasks : t.id in Parents)
       span(task[t], all(i in Hierarchy: i.parentId == t.id) task[<i.taskId>]); 
  
   // Precedence constraints
  forall (p in Precedences : p.type == "StartsAfterStart") 
      startBeforeStart(task[<p.beforeId>], task[<p.afterId>], p.delay);
  forall (p in Precedences : p.type == "StartsAfterEnd") 
      endBeforeStart(task[<p.beforeId>], task[<p.afterId>], p.delay);
  
   // Alternatives of workers who can fulfil task requirement (each requirement must be filled by one worker)
  forall(r in Requirements)
    alternative(task[<r.taskId>], all(a in Allocations: a.reqId==r.id) alts[a]);

   // Calculate whether each worker is used in the project using span constraint
  forall(w in Workers)
    span(workerSpan[w], all(a in Allocations: a.workerId==w.id) alts[a]);
    
  // A worker can fill only one task requirement at any point in time
  forall(w in Workers)
    noOverlap(all(a in Allocations: a.workerId==w.id) alts[a]);
    
};

tuple result_task{
   int taskId;
   int start;
   int end; 
} 

{result_task} results_tasks = {<t.id, startOf(task[t]), endOf(task[t])> | t in Tasks};

tuple result_alloc{
   int reqId;
   int taskId;
   int workerId;
   int start;
   int end; 
} 

{result_alloc} results_allocs = {<a.reqId, r.taskId, a.workerId, startOf(alts[a]), endOf(alts[a])> | r in Requirements, a in Allocations: r.id == a.reqId};

tuple result_worker{
   int workerId;
   string workerName;
   int start;
   int end; 
} 

{result_worker} results_workers = {<w.id, w.name, startOf(workerSpan[w]), endOf(workerSpan[w])> | w in Workers};

tuple result_task_date{
   int taskId;
   string start;
   string end; 
} 
{result_task_date} result_task_dates = {};

tuple result_alloc_date{
   int reqId;
   int taskId;
   int workerId;
   string start;
   string end; 
}
{result_alloc_date} result_alloc_dates = {};

tuple result_worker_date{
   int workerId;
   string workerName;
   string start;
   string end; 
}
{result_worker_date} result_worker_dates = {};

tuple workerTime{
  int workerId;
  string workerName;
  int duration;
}

{workerTime} workerTimes = {<w.id,w.name,workerTimeSpent[w]>|w in Workers};

execute{
  	workerTimes;
	for(var t in results_tasks){
		var start = t.start;
		var end = t.end;
		var start_date = new Date(2021, 1, 5, 0, start, 0);
  		var end_date = new Date(2021, 1, 5, 0, end, 0);
  		result_task_dates.add(t.taskId, String(start_date), String(end_date));
	}
	
	for(var t in results_allocs){
		var start = t.start;
		var end = t.end;
		var start_date = new Date(2021, 1, 5, 0, start, 0);
  		var end_date = new Date(2021, 1, 5, 0, end, 0);
  		result_alloc_dates.add(t.reqId, t.taskId, t.workerId, String(start_date), String(end_date));
	} 
	
	for(var t in results_workers){
		var start = t.start;
		var end = t.end;
		var start_date = new Date(2021, 1, 5, 0, start, 0);
  		var end_date = new Date(2021, 1, 5, 0, end, 0);
  		result_worker_dates.add(t.workerId, t.workerName, String(start_date), String(end_date));
	} 
};
