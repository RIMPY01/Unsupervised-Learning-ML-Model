--
-- File generated with SQLiteStudio v3.4.4 on Sun May 7 11:11:24 2023
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- View: MergedDataset
DROP VIEW IF EXISTS MergedDataset;
CREATE VIEW MergedDataset AS
    SELECT/* This view provides the data for the ML Model */ R.*,
           App.ApplicationSlateID,
           App.[HUB66:EntryTermadmit_term],-- App.[AppCounts:Summary],
           App_TurnAroundTime,-- App.Submitted,
           /* App.PermanentResident, */App.GDegreeConvertedGPA,
           App.GDegree_Ind,-- App.GDegreeSchoolCountry,
           GDegreeSchoolTranscriptSubmitted?,
           [AppForm:Auto-AdmitConfirmEligibilityYes/No],
           [AppForm:Auto-AdmitProcessingCompleteYes/No],
           [AppForm:GMAT/GREStandardizedTestWaiverOptInY/N(NotPMBA)],
           IntentToEnroll,
           InterestedTrack,
           OtherInstitutionsApplied?,
           OtherUBProgramApplied?,
           [Pre-EnrollmentSalaryRange],
           [AppForm:PreviousUBEnrollmentProgram],
           [StandardizedTestWaived(ReaderIndicator)],
           evnt.Events_NoShow,
           evnt.Events_Attended,
           evnt.Events_Registered,-- evnt.[Waitlist],
           evnt.Events_Cancelled,
           evnt.Events_Pending,
           coalesce(IT.Positive_Interaction_count, 0) AS Positive_Interaction_count,
           coalesce(IT.Negative_Interaction_count, 0) AS Negative_Interaction_count,-- fg.Degree as Grades_Degree,
           /* fg.Major as Grades_Major, */fg.CumulativeGPA AS Grades_CumulativeGPA-- fg.DegreeConferDate as Grades_DegreeConferDate
      FROM vw_Record R
           JOIN
           vw_Application App ON App.ref = R.ref
           JOIN
           vw_Final_Grades fg ON App.ref = fg.SlateID AND 
                                 FG.MAJOR = 'Management Info Systems MS'
           LEFT JOIN
           vw_Interactions IT ON App.ref = IT.SlateID
           JOIN
           vw_Events_Forms evnt ON App.ref = evnt.slateId;


-- View: vw_Application
DROP VIEW IF EXISTS vw_Application;
CREATE VIEW vw_Application AS
    SELECT ApplicationSlateID,
           Ref,
           [HUB66:EntryTermadmit_term],-- [AppCounts:Details],
           [AppCounts:Summary],-- [AppCounts:CurrentStanding],
           /* [AppCounts:ConfirmedStanding], */round(JulianDay(Submitted) - JulianDay(created), 0) AS App_TurnAroundTime,
           Submitted,
           PermanentResident,
           GDegreeConvertedGPA,
           CASE WHEN GDegreeType IS NOT NULL THEN 1 ELSE 0 END AS GDegree_ind,
           GDegreeSchoolCountry,
           CASE WHEN COALESCE(GDegreeSchoolTranscriptSubmitted?, 'No') = 'No' THEN 0 ELSE 1 END AS GDegreeSchoolTranscriptSubmitted?,
           CASE WHEN coalesce([AppForm:Auto-AdmitConfirmEligibilityYes/No], 0) = 0 THEN 0 ELSE 1 END AS [AppForm:Auto-AdmitConfirmEligibilityYes/No],
           CASE WHEN coalesce([AppForm:Auto-AdmitProcessingCompleteYes/No], 0) = 0 THEN 0 ELSE 1 END AS [AppForm:Auto-AdmitProcessingCompleteYes/No],
           CASE WHEN coalesce([AppForm:GMAT/GREStandardizedTestWaiverOptInY/N(NotPMBA)], 0) = 0 THEN 0 ELSE 1 END AS [AppForm:GMAT/GREStandardizedTestWaiverOptInY/N(NotPMBA)],
           CASE WHEN [AppForm:IntentiontoEnroll-Yes/NoConfirmationDEFERRAL] = 1 THEN 'Deferred' WHEN [AppForm:IntentiontoEnroll-Yes/NoConfirmationINITIAL] = 1 AND 
                                                                                                     [AppForm:IntentiontoEnroll-Yes/NoConfirmationFINAL] = 1 THEN 'Determined' ELSE 'UnSure' END "[IntentToEnroll]",
           CASE WHEN [AppForm:MSMISTrackforApplication] IS NULL THEN 'Unsure' ELSE [AppForm:MSMISTrackforApplication] END AS InterestedTrack,
           CASE WHEN COALESCE([AppForm:OtherInstitutionsAppliedY/N], 'Unknown') = 1 THEN 'Yes' ELSE COALESCE([AppForm:OtherInstitutionsAppliedY/N], 'Unknown') END AS OtherInstitutionsApplied?,
           CASE WHEN COALESCE([AppForm:OtherUBProgramAppliedY/N], 'Unknown') = 1 THEN 'Yes' ELSE COALESCE([AppForm:OtherUBProgramAppliedY/N], 'Unknown') END AS OtherUBProgramApplied?,
           COALESCE([AppForm:Pre-EnrollmentSalaryRange(Optional)], 'Unknown') AS [Pre-EnrollmentSalaryRange],
           COALESCE([AppForm:PreviousUBEnrollmentProgram], 'Unknown') AS [AppForm:PreviousUBEnrollmentProgram],
           CASE WHEN COALESCE([AppWaiver:StandardizedTestWaived(ReaderIndicator)], 0) = 0 THEN 0 ELSE 1 END AS [StandardizedTestWaived(ReaderIndicator)]
      FROM Application_new
     WHERE [AppCounts:currentstanding] = 'Accepted' AND 
           [AppCounts:ConfirmedStanding] IN ('Confirmed, Deposit Paid', 'Confirmed, Deposit waived') AND 
           [DecisionHistory(alldecisions)] NOT LIKE '%Defer Decision%' AND 
           [AppCounts:Summary] = 'MS MIS';
-- Created,-- Updated,-- GDegreeSchoolName,-- GDegreeStartDate,-- GDegreeEndDate,-- GDegreeMajor,-- [AppForm:4Plus1OptinforMSPrograms],-- [AppForm:ApplicationFeeWaiverPrograms],-- [AppForm:IntentiontoEnroll-DeclineReasons],-- [AppForm:MBACombinedorCollaborativeIndicator],-- [AppForm:MSFinanceTrackforApplication],-- [AppForm:OtherInstitutionsAppliedto#1],-- [AppForm:OtherInstitutionsAppliedto#2],-- [AppForm:OtherInstitutionsAppliedto#3],-- [AppForm:OtherUBProgramAppliedto#1],-- [AppForm:OtherUBProgramAppliedto#2],-- [AppForm:OtherUBProgramAppliedto#3],-- [AppForm:OtherUBProgramAppliedY/N],-- [AppForm:PreviousUBEnrollmentProgramCompleteYN],-- INTAppFormCurrentlyLiveinUSYN,-- [AppWaiver:StandardizedTestWaiverReason],-- [MissingAdmissionsChecklistItems(comma)],-- [FulfilledAdmissionsChecklistItems(comma)],-- [AdmissionsChecklistItemswithStatus(comma)]-- ApplicationStatus,-- Round,-- [DecisionHistory(alldecisions)]-- AppFeeReceivedDate-- AppFeeWaivedDate,-- DepositWaivedDate

-- View: vw_Events_Forms
DROP VIEW IF EXISTS vw_Events_Forms;
CREATE VIEW vw_Events_Forms AS
    SELECT SLATEID,
           sum(CASE WHEN FormResponseRegistrationStatus = "No Show" THEN 1 ELSE 0 END) AS Events_NoShow,
           sum(CASE WHEN FormResponseRegistrationStatus = "Attended" THEN 1 ELSE 0 END) AS Events_Attended,
           sum(CASE WHEN FormResponseRegistrationStatus = "Registered" THEN 1 ELSE 0 END) AS Events_Registered,-- sum(Case when FormResponseRegistrationStatus="Waitlist" then 1 else 0 end ) as[Waitlist],
           sum(CASE WHEN FormResponseRegistrationStatus = "Cancelled" THEN 1 ELSE 0 END) AS Events_Cancelled,
           sum(CASE WHEN FormResponseRegistrationStatus = "Pending" THEN 1 ELSE 0 END) AS Events_Pending
      FROM [Event-All] AS SRC
     WHERE SLATEID IS NOT NULL
     GROUP BY SLATEID;


-- View: vw_Final_Grades
DROP VIEW IF EXISTS vw_Final_Grades;
CREATE VIEW vw_Final_Grades AS
    SELECT *
      FROM [GRAD degrees with conferral GPA 425 SlateID];


-- View: vw_Interactions
DROP VIEW IF EXISTS vw_Interactions;
CREATE VIEW vw_Interactions AS
    SELECT SLATEID,
           sum(CASE WHEN interaction IN ('Recruitment: Connection', 'Recruitment: Email Received (Direct)', 'Recruitment: Encountered at Other UB Event', 'Recruitment: Inbound Call', 'Recruitment: In-Person Meeting', 'Recruitment: Notes - General Notes', 'Recruitment: Notes - Referral Notes', 'Recruitment: Outbound Call - Spoke with Person', 'Recruitment: Phone Call', 'Recruitment: Phone Meeting', 'Recruitment: Prospect Met with OSMEM SOM Staff', 'Recruitment: Prospect Met with Recruiter', 'Recruitment: Walk In') THEN 1 ELSE 0 END) AS Positive_Interaction_count,
           sum(CASE WHEN interaction IN ('Recruitment: Outbound Call - Disconnected Number', 'Recruitment: Outbound Call - No Answer', 'Recruitment: Outbound Call - No Answer & Left Message') THEN 1 ELSE 0 END) AS Negative_Interaction_count
      FROM Interactions
     WHERE interaction IN (/* positive */'Recruitment: Connection', 'Recruitment: Email Received (Direct)', 'Recruitment: Encountered at Other UB Event', 'Recruitment: Inbound Call', 'Recruitment: In-Person Meeting', 'Recruitment: Notes - General Notes', 'Recruitment: Notes - Referral Notes', 'Recruitment: Outbound Call - Spoke with Person', 'Recruitment: Phone Call', 'Recruitment: Phone Meeting', 'Recruitment: Prospect Met with OSMEM SOM Staff', 'Recruitment: Prospect Met with Recruiter', 'Recruitment: Walk In',/* Negative */ 'Recruitment: Outbound Call - Disconnected Number', 'Recruitment: Outbound Call - No Answer', 'Recruitment: Outbound Call - No Answer & Left Message') 
     GROUP BY SLATEID;


-- View: vw_Normalised_TestScores
DROP VIEW IF EXISTS vw_Normalised_TestScores;
CREATE VIEW vw_Normalised_TestScores AS
WITH cte AS (
        SELECT ref,
               CASE WHEN GMATTotal IS NOT NULL THEN ROUND( ( (GMATTotal / 800.0) * 100), 0) ELSE 0 END AS GMAT_Mod,
               CASE WHEN GREVerbal + GREQuantitative + GREAnalyticalWriting IS NOT NULL THEN ROUND( ( (GREVerbal + GREQuantitative + GREAnalyticalWriting) / 340.0) * 100, 0) ELSE 0 END AS GRE_Mod,
               CASE WHEN IELTSOverallBandScore IS NOT NULL THEN ROUND( (IELTSOverallBandScore / 9.0) * 100, 0) ELSE 0 END AS IELTS_Mod,
               CASE WHEN PTETotal IS NOT NULL THEN ROUND( (PTETotal / 90.0) * 100, 0) ELSE 0 END AS PTE_Mod,
               CASE WHEN TOEFLTotal IS NOT NULL THEN ROUND( (TOEFLTotal / 120.0) * 100, 0) ELSE 0 END AS TOEFL_Mod
          FROM Record_Cleansed
    )
    SELECT ref,
           CASE WHEN IELTS_Mod >= PTE_Mod AND 
                     IELTS_Mod >= TOEFL_Mod THEN IELTS_Mod WHEN PTE_Mod >= IELTS_Mod AND 
                                                                PTE_Mod >= TOEFL_Mod THEN PTE_Mod WHEN TOEFL_Mod >= IELTS_Mod AND 
                                                                                                       TOEFL_Mod >= PTE_Mod THEN TOEFL_Mod END AS English_Score,
           CASE WHEN GMAT_Mod >= GRE_Mod THEN GMAT_Mod WHEN GRE_Mod >= GMAT_Mod THEN GRE_Mod END AS Analytical_Score
      FROM cte;


-- View: vw_Record
DROP VIEW IF EXISTS vw_Record;
CREATE VIEW vw_Record AS
    SELECT rec.Ref,-- Birthdate,
           Age,
           Sex,
           Hispanic,
           Race,
           CitizenshipStatus,
           PrimaryCitizenship,-- SecondaryCitizenship,
           /* UGDegreeSchoolName, */UGDegreeConvertedGPA,
           CASE WHEN UGDegreeType LIKE 'B%' THEN 'Bachelor' WHEN UGDegreeType LIKE 'A%' THEN 'Associate' WHEN UGDegreeType LIKE 'Diploma%' THEN 'Diploma' WHEN COALESCE(UGDegreeType, 'No Degree Type') = 'No Degree Type' THEN 'Unknown' ELSE 'Others' END AS UGDegreeType,
           CASE WHEN UGDegreeType IN ('BTech', 'BE', 'BCA', 'EngD') THEN 'Engineering' WHEN UGDegreeType IN ('BComm') THEN 'Commerce' WHEN UGDegreeType IN ('BBA', 'BMS') THEN 'Management' WHEN UGDegreeType IN ('BSc', 'BA', 'BS', 'MSc', 'BEd', 'BAS', 'BFA', 'BDes', 'BJ', 'BSW') THEN 'Science/Arts' WHEN UGDegreeType LIKE 'Diploma%' THEN 'Diploma' WHEN UGDegreeType = 'LLB' THEN 'Law' WHEN UGDegreeType IN ('BPharm', 'MBBS', 'PharmD', 'BDS', 'BSN') THEN 'Medicine' WHEN UGDegreeType = 'BArch' THEN 'Architecture' WHEN UGDegreeType IN ('AS', 'AA', 'AAS', 'AOS') THEN 'Associate' WHEN COALESCE(UGDegreeType, 'No Degree Type') = 'No Degree Type' THEN 'Unknown' ELSE 'others' END AS UGDegreeMajorType,
           CASE WHEN COALESCE(UGDegreeSchoolTranscriptSubmitted?, 'No') = 'No' THEN 0 ELSE 1 END AS UGDegreeSchoolTranscriptSubmitted?,
           COALESCE(EmailsOpenedinPast60Days, 0) AS EmailsOpenedinPast60Days,
           COALESCE(EmailsClickedinPast60Days, 0) AS EmailsClickedinPast60Days,
           English_Score,
           Analytical_Score,
           CASE WHEN InquiryDate IS NOT NULL THEN 1 ELSE 0 END AS InquiryMadeInd,
           [Ping-TotalCount]
      FROM Record_Cleansed rec
           LEFT JOIN
           vw_Normalised_TestScores nm ON rec.ref = nm.ref;
-- UGDegreeStartDate,-- UGDegreeEndDate,-- UGDegreeMajor,-- UGDegreeConferredDate,-- UGDegreeSchoolState,-- UGDegreeSchoolCountry,-- Created,-- Updated,-- ActiveCountry,-- [ApplicationHistory(comma)],/* [%EmailsOpenedinPast60Days],
       [%EmailsClickedinPast60Days],
       MostRecentEmailOpenedSubject,
       MostRecentEmailOpenedDate,
       FirstEmailOpenedSubject,
       FirstEmailOpenedDate, *//* [DuolingoEnglishTest(160-pointscale)Score],
       GMATTotal,
       GREVerbal + GREQuantitative +GREAnalyticalWriting as GRETotal,
       IELTSOverallBandScore,
       PTETotal,
       TOEFLTotal, */-- School1Type,-- ApplicantDate,-- [Ping-TotalDuration(seconds)],/* [Ping-UniqueURLCount],
       [Ping-LastTimestamp],
       [Ping-FirstTimestamp] */

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
