# APRVD

<div align="center"><img src ="https://github.com/JStrawn/ApprovalRating/blob/master/Docs/img/app_icon.png" /></div>


Created for a news & politics themed hackathon, APRVD was inspired by a strong interest in data trends and the media's general attitudes towards public figures. The user searches for a celebrity or politician and receives the subject's "approval rating" over a set amount of time, along with recent articles this person has been mentioned in. 

When the user types in the person's name, the app makes four API calls. The first three are to return the number of articles which have positive, negative, and neutral sentiments from the past 3 days. We used the Webhose.io API, because it has an algorithm that scans the words of a news article and returns which of these three sentiments the article is likely expressing. The fourth API call searches for all recent articles about this person regardless of sentiment, and displays them in order of relevancy and popularity. To create this person's approval rating, we take the percentage of articles with positive sentiment from the total number of articles.

After the hackathon, I fixed several bugs and added some new features, like the custom table cells, images, and ability to open news articles in Safari. There are still a vew visual bugs, and there were planned features like allowing the user to shorten the default 3-day timeframe of search results. However, I ultimately decided to stop working on this project due to a problem that I *totally* should have seen coming: the internet is a very negative place, and no matter who you search for, approval ratings rarely go above 3%. Oh well, hindsight is 20/20.

# How To Use APRVD
To use APRVD for yourself, simply clone the project. Before the app will work, you have to get an API key from [WebHose.io](https://webhose.io). It's free as long as you don't go over 1000 requests per month, and APRVD makes 4 requests per search. Paste your API key in 'Model/DAO.m'. Then, build and run the Xcode project on either a simulator or a phone.

Please note that Webhose limits API calls to one per second, which affects loading times. 

# Screenshots
<div align="center"><img src="https://github.com/JStrawn/ApprovalRating/blob/master/Docs/img/IMG_1352.PNG" height="733" width="437">  <img src="https://github.com/JStrawn/ApprovalRating/blob/master/Docs/img/IMG_1478.PNG" height="733" width="437">  <img src="https://github.com/JStrawn/ApprovalRating/blob/master/Docs/img/IMG_1480.PNG" height="733" width="437">  <img src="https://github.com/JStrawn/ApprovalRating/blob/master/Docs/img/IMG_1477.PNG" height="733" width="437"></div>
