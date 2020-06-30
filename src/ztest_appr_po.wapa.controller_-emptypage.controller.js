sap.ui.define([                                                                                                                                                                                                                                                
		"ztest/purchaseorders/approve/controller/BaseController"                                                                                                                                                                                                     
	], function(BaseController) {                                                                                                                                                                                                                                 
	"use strict";                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                               
	/*                                                                                                                                                                                                                                                            
        Common base class for the controllers of this app containing some convenience methods                                                                                                                                                                  
    */                                                                                                                                                                                                                                                         
	return BaseController.extend("ztest.purchaseorders.approve.controller.EmptyPage", {                                                                                                                                                                           
                                                                                                                                                                                                                                                               
		onNavButtonPressed  : function(){                                                                                                                                                                                                                            
			this.getApplication().navBack(true, true);                                                                                                                                                                                                                  
		}                                                                                                                                                                                                                                                            
	});                                                                                                                                                                                                                                                           
});                                                                                                                                                                                                                                                            