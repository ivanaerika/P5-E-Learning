public with sharing class UnitService {
    public static Boolean getUnitIds(Id unitId, String jsonAnswer) {
        //busco la unidad con el id "unitId" en la base de datos
        Unit__c unit = [SELECT module__c FROM Unit__c WHERE Id=:unitId];
        //busco el modulo relacionado con el id de unidad asociados al usuario, si no existe , signfica que es la primera pregunta , creo el UserModule
        //veo si existe el userModule , sino lo creo
        //uso userInfo.getUserId() para obtener el id del usuario actual
        UserModule__c module;
        try{
            module = [SELECT Id FROM UserModule__c WHERE Module__c = :unit.Module__c  AND User__c = :UserInfo.getUserId() AND Status__c = 'In Progress'];
            }catch (Exception e){

           modulo = new UserModule__c(User__c = userInfo.getUserId(),
           Module__c = unit.Module__c,
           Status__c = 'In Progress');
           insert module;
           } 
        //creo el UserUnit en estado draft
        UserUnit__c unitResp = new UserUnit__c(Unit__c = unitId,
            UserModule__c = module.Id,
            Status__c = 'Draft',
            User__c = UserInfo.getUserId()
          );

    }

}

















//tengo mi trigger



//veo si la respuesta cambio de draft a answered y si esto paso , paso a la logica de ver si los puntos son correctos
public static void BeforeUpdate(List<UserUnit__c> UserUniList, Map<Id,UserUnit__c> oldUserUnitMap){
     List<UserUnit__c> answeredUnitList = new List<UserUnit__c>();
        for(UserUnit__c unitResp : UserUnitList){
            if(unitResp.Status__c == 'Answered' && oldUserUnitMap.get(unitResp.Id).Status__c == 'Draft'){
                answeredUnitList.add(unitResp);
            }
        }

     
        
}



public class TrailWrapper{
     Trail__c trail; //Registro de Trail solicitado
     List<Module__c> modules; //Módulos con Unidades relacionadas
    
     Set<Id> passedModuleIds; //Ids de modulos relacionados al Trail actual en los que el Alumno ya aprobo
     Set<Id> passedUnitIds; //Ids de Unidades relacionadas a modulos del Trail actual que el Alumno ya aprobo
     integer progressTrail; //Porcentaje de progreso del Alumno en el Trail

    public TrailWrapper (
                        Trail__c trail, 
                        List<Module__c> modules,
                        Set<Id> passedModuleIds, 
                        Set<Id> passedUnitIds){
        this.trail = trail;
        this.modules = modules;
        this.passedModuleIds = passedModuleIds;
        this.passedUnitIds = passedUnitIds;
    }
}