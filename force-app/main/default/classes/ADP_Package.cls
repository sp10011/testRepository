public class ADP_Package {
    
    /* Build.xml */
    /*
    <project name="Sample usage of Salesforce Ant tasks" default="test" basedir="." xmlns:sf="antlib:com.salesforce">

    <property file="build.properties"/>
    <property environment="env"/>

    <!-- Setting default value for username, password and session id properties to empty string 
         so unset values are treated as empty. Without this, ant expressions such as ${sf.username}
         will be treated literally.
    -->
    <condition property="sf.username" value=""> <not> <isset property="sf.username"/> </not> </condition>
    <condition property="sf.password" value=""> <not> <isset property="sf.password"/> </not> </condition>
    <condition property="sf.sessionId" value=""> <not> <isset property="sf.sessionId"/> </not> </condition>

    <taskdef resource="com/salesforce/antlib.xml" uri="antlib:com.salesforce">
        <classpath>
            <pathelement location="../ant-salesforce.jar" />        	
        </classpath>
    </taskdef>
	
    <!-- Test out deploy and retrieve verbs for package 'mypkg' -->
    <target name="test">
      <!-- Upload the contents of the "mypkg" package -->
      <sf:deploy username="${sf.username}" password="${sf.password}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" deployRoot="mypkg" rollbackOnError="true"/>
      <mkdir dir="retrieveOutput"/>
      <!-- Retrieve the contents into another directory -->
      <sf:retrieve username="${sf.username}" password="${sf.password}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" retrieveTarget="retrieveOutput" packageNames="MyPkg"/>
    </target>

	<target name="proxy">    
	 <property name="proxy.host" value="11.164.4.23" />
	 <property name="proxy.port" value="8080"/>
	 <property name="proxy.user" value="palamram"/>
	 <property name="proxy.pwd" value="VitalAdp90523ram"/>
	 <setproxy proxyhost="${proxy.host}" proxyport="${proxy.port}" proxyuser="${proxy.user}" proxypassword="${proxy.pwd}" />
	</target> 
	
	
    	
	
	<target name="retrieveUnpackagedee" depends="proxy">
      <mkdir dir="PWR11043"/>
      <!-- Retrieve the contents into another directory -->
      <sf:retrieve username="${sf.username}" password="${sf.password}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" retrieveTarget="PWR11043" unpackaged="PWR11043.xml"/>  
    </target>

	
	
	
	
    <!-- Retrieve all the items of a particular metadata type -->
    <target name="bulkRetrieve">
      <sf:bulkRetrieve username="${sf.username}" password="${sf.password}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" metadataType="${sf.metadataType}" retrieveTarget="retrieveUnpackaged"/>
    </target>

    <!-- Retrieve metadata for all the packages specified under packageNames -->
    <target name="retrievePkg">
      <sf:retrieve username="${sf.username}" password="${sf.password}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" retrieveTarget="retrieveOutput" packageNames="${sf.pkgName}"/>
    </target>

    <!-- Deploy the unpackaged set of metadata retrieved with retrieveUnpackaged and run tests in this organization's namespace only-->
    <target name="deploy_Metadata_Feb_IAT" depends="proxy">
      <sf:deploy username="${sf.iatusername}" password="${sf.iatpassword}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" deployRoot="Metadata_Feb_IAT" rollbackOnError="true"/>
    </target>

    <!-- Deploy a zip of metadata files to the org -->
    <target name="deployZip" depends="proxy">
      <sf:deploy username="${sf.username}" password="${sf.password}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" zipFile="${sf.zipFile}" pollWaitMillis="1000" rollbackOnError="true"/>
    </target>

    <!-- Shows deploying code & running tests for code in directory -->
    <target name="deployCode">
      <!-- Upload the contents of the "codepkg" directory, running the tests for just 1 class -->
      <sf:deploy username="${sf.username}" password="${sf.password}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" deployRoot="codepkg" testLevel="RunSpecifiedTests" rollbackOnError="true">
      	 <runTest>SampleDeployClass</runTest> 
      </sf:deploy>
    </target>
	
	 <!-- Shows deploying code with no TestLevel sepcified -->
    <target name="deployCodeNoTestLevelSpecified">
      <sf:deploy username="${sf.username}" password="${sf.password}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" deployRoot="codepkg" rollbackOnError="true"/>
    </target>
	
	<!-- Shows deploying code and running tests only within the org namespace -->
	<target name="deployCodeRunLocalTests">
	  <sf:deploy username="${sf.username}" password="${sf.password}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" deployRoot="codepkg" rollbackOnError="true"  testlevel="RunLocalTests"/>
	</target>
	
    <!-- Shows removing code; only succeeds if done after deployCode -->
    <target name="undeployCode">
      <sf:deploy username="${sf.username}" password="${sf.password}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" deployRoot="removecodepkg"/>
    </target>
	
	<!-- Shows retrieving code; only succeeds if done after deployCode -->
    <target name="retrieveCode_From_Dit" depends="proxy">
	  <!--<mkdir dir="Metadata_Mar_Dit_Badges"/>-->
      <!-- Retrieve the contents listed in the file codepkg/package.xml into the codepkg directory -->
      <sf:retrieve username="${sf.ditusername}" password="${sf.ditpassword}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" retrieveTarget="Meta_DIT" unpackaged="Retrieve_FROM_DIT/Package.xml"/>
    </target>

    <!-- Shows retrieving code; only succeeds if done after deployCode -->
    <target name="retrieveCode_From_FIT" depends="proxy">
	  <!--<mkdir dir="Meta_FIT_Three"/> -->
      <!-- Retrieve the contents listed in the file codepkg/package.xml into the codepkg directory -->
      <sf:retrieve username="${sf.fitusername}" password="${sf.fitpassword}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" retrieveTarget="FIT_Backup" unpackaged="Retrieve_FROM_DIT/Package.xml"/>
    </target>
	
	
	<!-- Shows retrieving code; only succeeds if done after deployCode -->
    <target name="retrieveCode_From_IAT" depends="proxy">
	  <mkdir dir="Muntaha_TestSandbox_Backup"/>  
      <!-- Retrieve the contents listed in the file codepkg/package.xml into the codepkg directory  -->
      <sf:retrieve username="${sf.iatusername}" password="${sf.iatpassword}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}"  retrieveTarget="Muntaha_TestSandbox_Backup" unpackaged="Retrieve_From_DIT/Package.xml"/>
    </target>
	
	<!-- Shows retrieving code; only succeeds if done after deployCode -->
    <target name="retrieveCode_PROD" depends="proxy">
	  <!--<mkdir dir="Prod_Backup"/> -->
      <!-- Retrieve the contents listed in the file codepkg/package.xml into the codepkg directory -->
      <sf:retrieve username="${sf.produsername}" password="${sf.prodpassword}" sessionId="${sf.sessionId}" serverurl="${sf.prodserverurl}" maxPoll="${sf.maxPoll}" retrieveTarget="Prod_Backup_Muntaha" unpackaged="Retrieve_FROM_DIT/Package.xml"/>
    </target>
	
	

	<!-- Shows deploying code, running all tests, and running tests (1 of which fails), and logging. -->
    <target name="validateCode_RunTest_PROD" depends="proxy">
      <!-- Upload the contents of the "codepkg" package, running all tests -->
      <sf:deploy username="${sf.produsername}" password="${sf.prodpassword}" sessionId="${sf.sessionId}" serverurl="${sf.prodserverurl}" maxPoll="${sf.maxPoll}" deployRoot="Muntaha_TestSandbox_Backup" testLevel="RunSpecifiedTests" rollbackOnError="true" checkonly="true" ignoreWarnings="true">
	  
		<runTest>Case_AutoSendRandom_StaffingSurvey_TEST</runTest>
    	<runTest>Case_AutoSend_AribaSurvey_Test</runTest>
    </sf:deploy>
    </target>
	
	
	
	<!-- Shows deploying code, running all tests, and running tests (1 of which fails), and logging. -->
    <target name="Destructive_PROD" depends="proxy">
      <!-- Upload the contents of the "codepkg" package, running all tests -->
      <sf:deploy username="${sf.produsername}" password="${sf.prodpassword}" sessionId="${sf.sessionId}" serverurl="${sf.prodserverurl}" maxPoll="${sf.maxPoll}" deployRoot="Meta_IAT"  rollbackOnError="true"  ignoreWarnings="true"> 
			<!--<runTest>INS_Account_Tracking_Test</runTest>	 -->
	  </sf:deploy>
    </target>
	
    <!-- Shows deploying code, running all tests, and running tests (1 of which fails), and logging. -->
    <target name="validateCode_RunTest__IAT" depends="proxy">
      <!-- Upload the contents of the "codepkg" package, running all tests -->
      <sf:deploy username="${sf.iatusername}" password="${sf.iatpassword}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" deployRoot="FIT_Backup" testLevel="RunSpecifiedTests" rollbackOnError="true" checkonly="true" ignoreWarnings="true">
			<runTest>createQuote_Test</runTest>
		    <runTest>OpportunityRecords_test</runTest>
	</sf:deploy>
    </target>
<!-- Shows deploying code, running all tests, and running tests (1 of which fails), and logging. -->
    <target name="validateCode_NoTest__IAT" depends="proxy">
      <!-- Upload the contents of the "codepkg" package, running all tests -->
      <sf:deploy username="${sf.iatusername}" password="${sf.iatpassword}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" deployRoot="Meta_FIT" testLevel="NoTestRun" rollbackOnError="true" checkonly="true" ignoreWarnings="true">
			
			
	  </sf:deploy>
    </target>	
	
	
	<!-- Shows deploying code, running all tests, and running tests (1 of which fails), and logging. -->
    <target name="Deploy_NoTest_FIT" depends="proxy">
      <!-- Upload the contents of the "codepkg" package, running all tests -->
      <sf:deploy username="${sf.fitusername}" password="${sf.fitpassword}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" deployRoot="Meta_DIT" testLevel="NoTestRun" checkonly="false" rollbackOnError="true" ignoreWarnings="true">
		
	  </sf:deploy>
    </target>
	
	<!-- Shows deploying code, running all tests, and running tests (1 of which fails), and logging. -->
    <target name="validateCode_RunTest_FIT" depends="proxy">
      <!-- Upload the contents of the "codepkg" package, running all tests -->
      <sf:deploy username="${sf.fitusername}" password="${sf.fitpassword}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" deployRoot="Meta_DIT" testLevel="RunSpecifiedTests" rollbackOnError="true" checkonly="true" ignoreWarnings="true">
		<!--
	      <runTest>OpportunityTriggerHandler_Test</runTest>	
	    -->
	  </sf:deploy>
    </target>
	
	<!-- Shows deploying code, running all tests, and running tests (1 of which fails), and logging. -->
    <target name="deleteCode_NoRunTest_FIT" depends="proxy">
      <!-- Upload the contents of the "codepkg" package, running all tests -->
      <sf:deploy username="${sf.fitusername}" password="${sf.fitpassword}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" deployRoot="destructiveChanges_FIT" testLevel="NoTestRun" rollbackOnError="true" checkonly="true" ignoreWarnings="true">
						 	
	  </sf:deploy>
    </target>
	
	 <target name="deleteCode_NoRunTest_IAT" depends="proxy">
      <!-- Upload the contents of the "codepkg" package, running all tests -->
      <sf:deploy username="${sf.iatusername}" password="${sf.iatpassword}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" deployRoot="Destructive_IAT"  rollbackOnError="true">
						 	
	  </sf:deploy>
    </target>
	
	
	<target name="deployCode_NoTestRun_FIT" depends="proxy">
      <sf:deploy username="${sf.fitusername}" password="${sf.fitpassword}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" deployRoot="Meta_DIT" testLevel="NoTestRun" rollbackOnError="true"/>
    </target>
	
	<target name="deployCodeNoTestLevelSpecified_Fit" depends="proxy">
      <sf:deploy username="${sf.fitusername}" password="${sf.fitpassword}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" deployRoot="Dit_March_Remove_Meta_Fit" rollbackOnError="true"/>
    </target>
	
	 <!-- Shows deploying code, running all tests, and running tests (1 of which fails), and logging. -->
    <target name="validateCode_DIT" depends="proxy">
      <!-- Upload the contents of the "codepkg" package, running all tests -->
      <sf:deploy username="${sf.ditusername}" password="${sf.ditpassword}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" deployRoot="Meta_DIT" testLevel="NoTestRun" rollbackOnError="true" checkonly="true" ignoreWarnings="true">			
	  </sf:deploy>
    </target>

    <!-- Shows check only; never actually saves to the server -->
    <target name="DIT_deployCodeCheckOnly" depends="proxy">
      <sf:deploy username="${sf.ditusername}" password="${sf.ditpassword}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" deployRoot="Dit_March_Remove" ignoreWarnings="true"/>
    </target>
	
	<!-- Shows quick deployment of recent validation. Set the property sf.recentValidationId to your recent check only deployment Id -->
	<target name="quickDeploy">
	  <sf:deployRecentValidation  username="${sf.username}" password="${sf.password}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" recentValidationId="${sf.recentValidationId}"/>
	</target>
	
	<!-- Shows cancel deployment of deploy request either pending or in progress. Set property sf.requestId to Id of pending or in progress deploy request -->
	<target name="cancelDeploy">
	  <sf:cancelDeploy  username="${sf.username}" password="${sf.password}" serverurl="${sf.serverurl}" maxPoll="${sf.maxPoll}" requestId="${sf.requestId}"/>
	</target>

	<!-- Retrieve the information of all items of a particular metadata type -->
    <target name="listMetadata">
      <sf:listMetadata username="${sf.username}" password="${sf.password}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}" metadataType="${sf.metadataType}"/>
    </target>

	<!-- Retrieve the information on all supported metadata type -->
    <target name="describeMetadata">
      <sf:describeMetadata username="${sf.username}" password="${sf.password}" sessionId="${sf.sessionId}" serverurl="${sf.serverurl}"/>
    </target>
</project> 
*/
    
    
    
    /* Build.properties */
    /*
     # build.properties
#

# Specify the login credentials for the desired Salesforce organization
#sf.username = rama.palam@adp.com.sbcomm
#sf.password = sales@90523Qq1kVrICJG0sBCbsNmR4RZ0P

#sf.username = rpalam111@salesforce.com
#sf.password = 9951692328@111mapaaaAtgorIuX0YFaUHsGIMTNbHKB

sf.ditusername = sumit.pandey@adp.com.dit
sf.ditpassword = sales@1122334455

sf.fitusername = sumit.pandey@adp.com.fit
sf.fitpassword = sales@1122334455

sf.iatusername = sumit.pandey2@adp.com.iat
sf.iatpassword = Aece270@11223344

sf.produsername = sumit.pandey2@adp.com
sf.prodpassword = Aece270@11223344

#sf.sessionId = <Insert your Salesforce session id here.  Use this or username/password above.  Cannot use both>
#sf.pkgName = <Insert comma separated package names to be retrieved>
#sf.zipFile = DeleteClass.zip
#sf.metadataType = <Insert metadata type name for which listMetadata or bulkRetrieve operations are to be performed>

# Use 'https://login.salesforce.com' for production or developer edition (the default if not specified).
# Use 'https://test.salesforce.com for sandbox.
sf.serverurl = https://test.salesforce.com
sf.prodserverurl = https://login.salesforce.com
#sf.serverurl = https://login.salesforce.com

sf.maxPoll = 2000
# If your network requires an HTTP proxy, see http://ant.apache.org/manual/proxy.html for configuration.
# 


      
     */
    
    
    /* Package.xml */
    
    /*
	 
	<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
   
    <types>
		<members>MyHitListsController</members>
		<members>DisplayFieldsSettingHandler</members>
		<members>DisplayFieldsSettingHandlerTest</members>
		<members>MyHitListsControllerTest</members>
		<name>ApexClass</name>
	</types>
	
	<types>
		<members>LPOC_HitList_v2</members>
		<name>AuraDefinitionBundle</name>
	</types>
	
	<version>41.0</version>
</Package>


     */


}