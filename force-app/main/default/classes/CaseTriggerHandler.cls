public class CaseTriggerHandler {
    
    /********************
* Commented out in July 2018 as it is replaced by Process Builder.
* 
* 
* *********************/
   /* public static string CLOSED = 'Closed';
    public static string RESOLUTION_TIME = 'Resolution';
    
    public static void checkClosedCases(List<Case> updatedCasesNew, Map<Id,Case> updatedCasesOldMap) { 
        system.debug('Entered method ClosedCases. updatedCasesNew : '+updatedCasesNew);
        DateTime completionDate = System.now(); 
        List<Id> updateCases = new List<Id>();
        List<Case> updateCasesList = New List<Case>();
        for (Case c : updatedCasesNew){
            Case oldCase = updatedCasesOldMap.get(c.Id);
            if (((c.isClosed == true && oldCase.isClosed != true)||(c.Status == CLOSED && oldCase.Status != CLOSED))&&((c.SlaStartDate <= completionDate)&&(c.SlaExitDate == null))) 
                updateCases.add(c.Id);
                updateCasesList.add(c);
        }
        if (updateCases.isEmpty() == false) {
            system.debug('updateCases : '+updateCases);
            system.debug('updateCasesList : '+updateCasesList);
            milestoneUtils.completeMilestone(updateCases, RESOLUTION_TIME, completionDate);
        }
    } */
    
}