# VendorLocator-Flutter

THIS PROJECT HAS BEEN CREATED BY ME TO HELP RECRUITERS REVIEW MY ANDROID DEVELOPMENT SKILLS.
VendorLocator which was previously a HTML based website created by me has now been migrated to an Android application using Flutter.
In this application, a user can add the location of a vendor on the map along with other details to promote his/her services or products and thereby help other needy users who can spot the location of that vendor using the application.
This application is for both the vendors who want to promote their shops as well as other random people who wish to help out a vendor on the street by putting their information on the app.

IMPORTANT:
On installing the application, the Login page is prefilled with a Guest Login ID and Password in order to fasten the process. In case anyone wants to register a new Login ID they can do so using the Sign Up function. 
The User details are authenticated using Firebase Authentication and use login details (except the password) is stored on Firebase.
I have used Google Maps API for Map operations. Other data like the Latitude and Longitude coordinates of the vendors and the vendor details are stored in Firestore Cloud Database.
You can view the front-end and back-end activity through the provided screenshots.

How To Operate The App:
1. Login (Create account if not already present)
2. Tap on the Map to add a location pin and vendor details.
3. On submitting the information, the details get stored in Google Cloud Firestore Database.
4. The vendor location and information is collected from the same database which is then displayed as location pins on the map to other users who are using the application.
5. If a user taps on the location pin of a vendor, he/she can see the vendor information which was stored in the database.

