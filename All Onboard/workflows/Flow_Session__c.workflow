<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>All_Onboard_Two_Factor_Authentication_Code_Is_Set</fullName>
        <description>All Onboard - Two Factor Authentication Code Is Set</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Onboard_Templates/Custom_All_Onboard_Two_Factor_Authentication_Email</template>
    </alerts>
</Workflow>
