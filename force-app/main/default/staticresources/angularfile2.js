'use strict'

function getUrlParameter(name) {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
    var results = regex.exec(location.search);
    return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
};

function parseJSONData(result){
	var tmpStrRes = JSON.stringify(result);
    tmpStrRes = tmpStrRes.replace(/&(lt|gt|quot|#39|amp);/g, function (m, p) { 
           return (p == "lt")? "<" : (p == "gt") ? ">" : (p == "#39") ? "\'": (p == "amp")? "&" : "\\\"";
        });   // escape quotes
    var varTitle = $('<textarea />').html(tmpStrRes).text(); // for removing &quot; from result string
    return jQuery.parseJSON( varTitle);
};
	
var app = angular.module('app', [
    'ui.bootstrap',
    'ngAnimate'
]);

app.factory('ajaxService', function($http, $log, $q) {
	return {
	   searchAccount: function(searchWord) {
	    	var deferred = $q.defer();
	    	Visualforce.remoting.timeout = 120000;
			Visualforce.remoting.maxretries = 2;
			Visualforce.remoting.Manager.invokeAction(
				'ADP_ElPaso_New_AutoComplete_Controller.getData',
				"Account", "NumberOfEmployees", "Name", "BillingCountry", "BillingCity", "BillingState", "BillingPostalCode", "BillingStreet", "Owner.Name", "Id", "", "", "", searchWord,
				function(result, event){
					if(event.status){ 
						//console.info("search results : ", result);
						result = parseJSONData(result);
						deferred.resolve(result);
					} else if (event.type === 'exception') {
		                console.error("exception has raised!");
		                console.error(event.where + " - " +event.message);
		                deferred.reject(event.message);
		            } else {
		                console.error(event.message);
		                deferred.reject(event.message);
		            }
				}
		    );	     
	    	return deferred.promise;
	    }
	}
});

app.controller('appController', ['$window', '$scope', '$uibModal', 'ajaxService', function ($window, $scope, $uibModal, ajaxService) {
	$scope.searchstr = "";
	$scope.displayRecord = false;
	$scope.loadingResults = false;
	$scope.selectedRecord = null;
	$scope.currentAcccount = null;
	$scope.hasFieldSet = false;
	$scope.firstHalfFieldSets = [];
	$scope.secondHalfFieldSets = [];
	$scope.IsMobile = false;
	$scope.shortestWidth = false;
	$scope.hideReqBtn = false;
	$scope.containerClass = "container";
	$scope.reasonforaccess = "";
	$scope.curRecordId = '';
	$scope.curRecordSource = '';
	$scope.reqBtnLabel = "Request for access";

	$scope.msgCls = "bg-success";
    $scope.msgText = "Request for the access to the Account has been sent to the Owner of the Account.";
    $scope.msgIcon = "fa-check-circle";

	Visualforce.remoting.timeout = 120000;
	Visualforce.remoting.maxretries = 2;

	if(window.matchMedia("only screen and (max-device-width: 768px)").matches) {
		$scope.IsMobile = true;
	}

	if($window.location.href.indexOf("sfdcIFrameOrigin") > -1) {
		$scope.shortestWidth = true;
		$("#findAccBody").removeClass("kitchen-sink");
	} else if($scope.IsMobile) {
		$scope.containerClass = "container-fluid";
		$(".search-results").addClass("hide");
	} else {
		$(".search-results").removeClass("hide");
	}
	

	$scope.CONST = {};
	$scope.CONST.SFDC = "sfdc";
	$scope.CONST.DATACOM = "datacom";
	$scope.CONST.AVENTION = "avention";
	$scope.dbsrc = $scope.CONST.SFDC;

	$scope.selectedSFDCRecIndex = null;
	$scope.selectedDataComRecIndex = null;
	$scope.selectedAventionRecIndex = null;
	
	$scope.searchResults = {
		"SFDC"    : [],
		"datacom" : [],
		"Avention": []
	};

	$scope.hideTABS = function() {
    	Visualforce.remoting.Manager.invokeAction(
			'ADP_ElPaso_New_AutoComplete_Controller.getUserInfo',
			function(result, event){
				if(event.status){ 
					result = parseJSONData(result);
					console.info("Current User Info : ", result);
					var pattern = /^ESI/i
					if(pattern.test(result.Business_Unit_Derived__c)) {
						$("ul.nav.nav-tabs").show();
					} else {
						$("ul.nav.nav-tabs").hide();
					}					
				} else if (event.type === 'exception') {
	                console.error("exception has raised!");
	                console.error(event.where + " - " +event.message);
	            } else {
	                console.error(event.message);
	            }
			}
	    );
    };
    $scope.hideTABS();

	$scope.clearSearchStr = function() {
		$scope.searchstr = "";
		$scope.resetSearchResults();
		$scope.resetIndexes();
		if($scope.IsMobile || $scope.shortestWidth) { $(".search-results").addClass("hide"); }
		$(".search-form .fa-chevron-down").removeClass("rotate180");
		$scope.changeMainContentView(false);
	};

	$scope.toggleSearchResults = function() {
		$(".search-results").toggleClass("hide");
		$(".search-form .fa-chevron-down").toggleClass("rotate180");
	};

	$scope.changeMainContentView = function(bool) {
		$scope.displayRecord = bool;
	};

	$scope.resetSearchResults = function() {
		$scope.searchResults.SFDC     = [];
		$scope.searchResults.datacom  = [];
		$scope.searchResults.Avention = [];
	};

	$scope.resetIndexes = function() {
		$scope.selectedSFDCRecIndex = null;
		$scope.selectedDataComRecIndex = null;
		$scope.selectedAventionRecIndex = null;
	};

	$scope.searchAccounts = function() {
		if($scope.searchstr.length > 2) {
			if($scope.IsMobile || $scope.shortestWidth) { 
				$(".search-results").removeClass("hide"); 
			}
			$scope.loadingResults = true;
			
			var promise = ajaxService.searchAccount($scope.searchstr);
			promise.then(function(results) { 
				$scope.resetSearchResults();
				for (var i = 0; i < results.length; i++) {
					switch(results[i].recSource.toLowerCase()) {
						case $scope.CONST.SFDC:
							$scope.searchResults.SFDC.push(results[i]);
							break;
						case $scope.CONST.DATACOM:
							$scope.searchResults.datacom.push(results[i]);
							break;
						case $scope.CONST.AVENTION:
							$scope.searchResults.Avention.push(results[i]);
							break;
					}
				};

				setTimeout(function(){
					if($scope.searchResults.SFDC.length == 0) {
						if($scope.searchResults.datacom.length == 0) {
							if($scope.searchResults.Avention.length == 0) {
								//do nothing
							} else {
								//select Avention Tab as there is no data for SFDC, Data.com
								$( "li[heading='Avention']" ).children()[0].click();
							}
						} else {
							//select Data.com Tab as there is no data for SFDC
							$( "li[heading='Data.com']" ).children()[0].click();
						}
					}
				}, 1500);
				

      		},
      		function(errMsg) {
      			console.error("Error getting search results");
      			console.error(errMsg);
      		});

			$scope.loadingResults = false;
		} else if($scope.searchstr.length == 0) {
			$scope.clearSearchStr();
		}
	};

	$scope.populateAccountDetails = function(record, index, src) {
		$scope.selectedRecord = record;
		if($scope.shortestWidth) { 
			//console.info($window.location.hostname);
			$window.top.open("/apex/zEx_ElPaso_Mobile?recId="+record.recId+"&source="+record.recSource+"&qs="+$scope.searchstr, "_self");
			return;
		}
		if($scope.IsMobile) { $(".search-results").addClass("hide"); }
		$scope.changeMainContentView(true);

		$scope.resetIndexes();
		$scope.dbsrc = src;
		switch(src) {
			case $scope.CONST.SFDC:
				$scope.selectedSFDCRecIndex = index;
				$scope.curRecordId = record.recId;
				$scope.curRecordSource = 'SFDC';
				$scope.checkRecordAccessStatus();
				break;
			case $scope.CONST.DATACOM:
				$scope.selectedDataComRecIndex = index;
				$scope.curRecordSource = 'Datacom';
				break;
			case $scope.CONST.AVENTION:
				$scope.selectedAventionRecIndex = index;
				$scope.curRecordSource = 'Avention';
				break;
		}
	};

	$scope.requestAccess = function() {
		$scope.dismissiblePopover.close();
		var recordId = $scope.curRecordId;	
		var reasonText = $('textarea#reasonarea').val();

		Visualforce.remoting.Manager.invokeAction(
			'ADP_ElPaso_New_AutoComplete_Controller.InsertUserIntoAccountTeam',
			reasonText, recordId,
			function(result, event){
				if(event.status){ 
					result = parseJSONData(result);
					console.info("Requested for access : ", result);
					$scope.msgCls = "bg-success";
	                $scope.msgText = "Request for the access to the Account has been sent to the Owner of the Account.";
	                $scope.msgIcon = "fa-check-circle";
					$("#requestStatus").show();
					$scope.checkRecordAccessStatus();
				} else if (event.type === 'exception') {
	                console.error("exception has raised!");
	                console.error(event.where + " - " +event.message);
	                $scope.msgCls = "bg-danger";
	                $scope.msgText = "Oops! There is some error. Could not sent the request.";
	                $scope.msgIcon = "fa-exclamation-circle";
	                $("#requestStatus").show();
	            } else {
	                console.error(event.message);
	            }
			}
	    );
	};

	$scope.createAccount = function() {
		var recString = JSON.stringify($scope.selectedRecord);
		Visualforce.remoting.Manager.invokeAction(
			'ADP_ElPaso_New_AutoComplete_Controller.createAccount',
			$scope.dbsrc, recString,
			function(result, event){
				if(event.status){ 
					console.info("Redirecting to create account page", result);
					var host = window.location.protocol + "//" + window.location.hostname + result;
					
					var uri_enc = encodeURIComponent(host);
    				var uri_dec = decodeURIComponent(uri_enc);
					uri_dec = uri_dec.replace(/\&amp;/g, "&");

					console.info("uri_dec", uri_dec);
					if($scope.shortestWidth) {
						window.parent.location.href = uri_dec;
					} else {
						window.location.href = uri_dec;
					}					
					
				} else if (event.type === 'exception') {
	                console.error("exception has raised!");
	                console.error(event.where + " - " +event.message);
	            } else {
	                console.error(event.message);
	            }
			}
	    );
	};

	$scope.closeMsg = function() {
		$("#requestStatus").hide();
	};

	$scope.dismissiblePopover = {

        isOpen: false,

        templateUrl: 'popover-dismissible.html',

        open: function() {
            $scope.dismissiblePopover.isOpen = true;
        },

        close: function() {
            $scope.dismissiblePopover.isOpen = false;
        }
    };    

    $scope.goToAccountPage = function() {
    	console.info($window.location.origin + "/"+ $scope.selectedRecord.recId);
    	$window.open($window.location.origin + "/"+ $scope.selectedRecord.recId);
		return;
    };
	
	
    $scope.checkRecordAccessStatus = function() {
		if($scope.curRecordSource == 'SFDC'){
			Visualforce.remoting.Manager.invokeAction(
				'ADP_ElPaso_New_AutoComplete_Controller.getSelectedAccount',
				$scope.curRecordId, "NumberOfEmployees", "Name", "BillingCountry", "BillingCity", "BillingState", "BillingPostalCode", "BillingStreet", "Owner.Name", "Id",
				function(result, event){
					if(event.status){ 
						result = parseJSONData(result);
						console.info("populate selected account : ", result);
						$scope.selectedRecord = result.wrapper[0];	
						$scope.currentAccount = result.accRecord;
						$scope.hasFieldSet = result.hasFieldSet;
						$scope.firstHalfFieldSets = [];
						$scope.secondHalfFieldSets = [];
						if(result.hasFieldSet){
							if(result.fieldSet.length%2==0){
								for(var i=0;i<result.fieldSet.length/2;i++)
									$scope.firstHalfFieldSets.push(result.fieldSet[i]);
								for(var i=result.fieldSet.length/2;i<result.fieldSet.length;i++)
									$scope.secondHalfFieldSets.push(result.fieldSet[i]);
							}else{
								for(var i=0;i<=result.fieldSet.length/2;i++)
									$scope.firstHalfFieldSets.push(result.fieldSet[i]);
								for(var i=(result.fieldSet.length/2)+0.5;i<result.fieldSet.length;i++){								
									$scope.secondHalfFieldSets.push(result.fieldSet[i]);
								}
							}
						}					
						$scope.changeMainContentView(true);
						$scope.hideReqBtn = result.wrapper[0].hideReqBtn;
						console.log($scope.hasFieldSet && true);
						$scope.$apply();
					} else if (event.type === 'exception') {
						console.error("exception has raised!");
						console.error(event.where + " - " +event.message);
					} else {
						console.error(event.message);
					}
				}
			);
		} else if($scope.curRecordSource == 'Datacom') {
			Visualforce.remoting.Manager.invokeAction(
				'ADP_ElPaso_New_AutoComplete_Controller.getSelectedDatacomAccount',
				$scope.curRecordId,
				function(result, event){
					if(event.status){ 
						result = parseJSONData(result);
						console.info("populate selected account : ", result);
						$scope.selectedRecord = result.wrapper[0];
						$scope.hasFieldSet = result.hasFieldSet;
						$scope.dbsrc = "datacom";
						$scope.changeMainContentView(true);
						$scope.$apply();	
					} else if (event.type === 'exception') {
						console.error("exception has raised!");
						console.error(event.where + " - " +event.message);
					} else {
						console.error(event.message);
					}
				}
			);
		} else if($scope.curRecordSource == 'Avention') {
			Visualforce.remoting.Manager.invokeAction(
				'ADP_ElPaso_New_AutoComplete_Controller.getSelectedAventionAccount',
				$scope.curRecordId,
				function(result, event){
					if(event.status){ 
						result = parseJSONData(result);
						console.info("populate selected account : ", result);
						$scope.selectedRecord = result.wrapper[0];
						$scope.hasFieldSet = result.hasFieldSet;
						$scope.dbsrc = "avention";
						$scope.changeMainContentView(true);
						$scope.$apply();
					} else if (event.type === 'exception') {
						console.error("exception has raised!");
						console.error(event.where + " - " +event.message);
					} else {
						console.error(event.message);
					}
				}
			);
		}
    };

    $scope.viewHierarchy = function() {
    	//open hierarchy of record in popup
    	$("#accHierarchy").attr("src", "/apex/zEx_ElPaso_Hierarchy?AccountId="+$scope.curRecordId);
    	$("#viewhierarchy").show();
    };

    $scope.closeHierarchy = function() {
    	//open hierarchy of record in popup
		$("#viewhierarchy").hide();
    };   

	if($window.location.search != "") {
		
		$scope.curRecordId = getUrlParameter('recId');
		$scope.curRecordSource = getUrlParameter('source');
		if($scope.curRecordId != '') {
			$scope.checkRecordAccessStatus();
		}

		if($scope.curRecordSource != '') {
			var curRecSrc = $scope.curRecordSource;
			setTimeout(function(){
				switch(curRecSrc){
					case "Datacom":
						$( "li[heading='Data.com']" ).children()[0].click();
						break;
					case "Avention":
						$( "li[heading='Avention']" ).children()[0].click();
						break;
				}
			}, 1000);
		}

		var queryStr = getUrlParameter('qs');
		if(queryStr != '') {
			$scope.searchstr = queryStr;
			$scope.searchAccounts();
		}
	}

}]);

