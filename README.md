# Artsy

This application is a passion project that brings a user self awareness from their Instagram profile. This was my first exploration into sentiment analysis, and was developed over a 2 day timespan.

##The User Experience

A user can login to their Instagram account. They are taken to a page that shows them a visual representation of the emotions portrayed by their images, as well as a list of the 20 top words associated with those images.

##The Developer Experience

###Summary:
I parsed two separate lexicons of color-word, and word-emotion relationships to create a SQL database. The lexicons are from Saif M. Mohammad's sentiment analysis research, which can be found [here](http://saifmohammad.com/WebPages/ResearchAreas.html). I integrated an API that analyzed color density, and queried the database to determine the word and emotion relationships with each photo. I then used Highcharts to give users a visual representation of the emotions associated with their photo collection.

###Details:
I used the Instagram gem to use the Instagram API. Documentation can be found [here](https://github.com/facebookarchive/instagram-ruby-gem).

I used the [ColorTag API](http://apicloud.me/apis/colortag/docs/) to get an array of colors for each photo. I iterate through this color array and query the database to find the words associated with that color. I then give a higher weight to the words associated with colors that are repeated in the collection of photos.

I repeated this process in order to integrate Highcharts. For future development, I'd like to increase the efficiency of this process.

