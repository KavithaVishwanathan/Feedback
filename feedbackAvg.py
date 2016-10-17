def calculateFeedbackAvg (int feedbackId):
	int[] sId = getSurveyIds(feedbackId)    #get list of survey ids for the given feedback
	int avg = 0
	for id in sID :
	 avg = avg + calculateSurveyAvg(id)     #calculate the average for each survey

	return avg/len(sid)

def getSurveyIds(int id):
   int[] ids = executeCommand("SELECT s.survey_id FROM feedback as f INNER JOIN survey  as s on f.feedback_id = s.feedback_id WHERE f.feedback_id = %d", id)
   return ids

def calculateSurveyAvg(int sId):
    int[] answers =  executeCommand("SELECT s.answer FROM survey as s, survey_answers as sa WHERE s.survey_id = %d", sId)
	int sum = 0
	for ans in answers:
	     sum = sum + (ans * 2) 
	
	return sum/len(answers)