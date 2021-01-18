/****************************************************
 * ILOG CP Optimizer Training
 *
 * Project scheduling SOL 2 - Worker assignment
 ****************************************************/

using CP;
 
/********
 * Data *
 ********/

tuple Task {
  key int id;
  string  name;
  int     ptMin; // minimum duration
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

// KPIs
float MakespanWeight     = ...;
float FixedWeight        = ...;
float VariableWeight = ...;

int MaxInterval = 10000001;

/**********************
 * Decision variables *
 **********************/
 
dvar interval task[t in Tasks] size t.ptMin..MaxInterval;
dvar interval alts[a in Allocations] optional;
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
  // Hierarchy structure
  forall (t in Tasks : t.id in Parents)
       span(task[t], all(i in Hierarchy: i.parentId == t.id) task[<i.taskId>]); 
       
   // Precedence constraints
  forall (p in Precedences : p.type == "StartsAfterStart") 
      startBeforeStart(task[<p.beforeId>], task[<p.afterId>], p.delay);
  forall (p in Precedences : p.type == "StartsAfterEnd") 
      endBeforeStart(task[<p.beforeId>], task[<p.afterId>], p.delay);
  
  // Alternatives of (each requirement must be perfomed by one worker)
  forall(r in Requirements)
    alternative(task[<r.taskId>], all(a in Allocations: a.reqId==r.id) alts[a]);

  // A worker can perform only one task requirement at any point in time
  forall(w in Workers)
    noOverlap(all(a in Allocations: a.workerId==w.id) alts[a]);
    
  // Calculate whether each worker is used in the project
  forall(w in Workers)
    span(workerSpan[w], all(a in Allocations: a.workerId==w.id) alts[a]);
    	
};

tuple result{
   int taskId;
   int start;
   int end; 
} 

{result} results = {<t.id, startOf(task[t]), endOf(task[t])> | t in Tasks};

execute{results};
