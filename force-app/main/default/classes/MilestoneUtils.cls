public class MilestoneUtils {
    
    /*******************************
* @created zSule@deloitte.nl 
* Ocotber 2017
* 
*
* Rebecca Weyers (rebecca.weyers@nextviewconsulting.com): At this point in time (04.02.2021), this Utilmethod is only used within CaseTriggerHandler which is commented out.
* Therefore, this class is considered deprecated and may be deleted in the future. 
* 
* *******************************/
    
    public static void completeMilestone(List<Id> caseIds, String milestoneName, DateTime complDate) {  
        system.debug('caseIds : '+caseIds);
        system.debug('entered completeMilestone : '+ milestoneName);
        List<MilestoneType> milestoneTypeList = [Select id, name from MilestoneType];
        system.debug('milestoneTypeList : '+ milestoneTypeList);
        List<CaseMilestone> allcases = [Select id, completionDate, MilestoneType.Name from CaseMilestone];
        system.debug('allcases : '+allcases);
        List<CaseMilestone> cmsToUpdate = [select Id, completionDate from CaseMilestone cm where caseId in :caseIds and cm.MilestoneType.Name=:milestoneName 
                                           and completionDate = null limit 1];
        system.debug('cmsToUpdate before : '+cmsToUpdate);
        if (cmsToUpdate.isEmpty() == false){
            for (CaseMilestone cm : cmsToUpdate){
                cm.completionDate = complDate;
            }
            system.debug('cmsToUpdate after : '+ cmsToUpdate);
            update cmsToUpdate;
        }
    }
}