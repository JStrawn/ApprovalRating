# APRVD

!


Created for a news & politics themed hackathon, APRVD was inspired by a strong interest in data trends and the media's general attitudes towards public figures. The user searches for a celebrity or politician and receives the subject's "approval rating" over a set amount of time, along with recent articles this person has been mentioned in. 

When the user types in the person's name, the app makes four API calls. The first three are to return the number of articles which have positive, negative, and neutral sentiments from the past 3 days. We used the Webhose.io API, because it has an algorithm that scans the words of a news article and returns which of these three sentiments the article is likely expressing. The fourth API call searches for all recent articles about this person regardless of sentiment, and displays them in order of relevancy and popularity. To create this person's approval rating, we take the percentage of articles with positive sentiment from the total number of articles.

I ultimately decided to stop working on this project due to a problem that I totally should have seen coming: the internet is a very negative place, and no matter who you search for, approval ratings rarely go above 3%. Oh well, hindsight is 20/20.
