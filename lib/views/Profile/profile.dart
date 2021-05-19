import 'package:flutter/material.dart';
import 'package:dezon/models/Job.dart';

import 'package:dezon/constants.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body:
          SingleChildScrollView( 
          child: Container(
        color: backgroundColor,
        child:
         Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(40),
                  constraints: BoxConstraints.expand(height: 225),
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                      colors: [gradientFirstColor, gradientSecondColor],
                      begin: const FractionalOffset(1.0, 1.0),
                      end: const FractionalOffset(0.2, 0.2),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp
                    ),
                    /* borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight:  Radius.circular(30)) */
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 50,right:20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Profil', style: titleStyleWhite,)
                      ],
                    ),
                  ),
                ),
                Container(
                  
                  margin: EdgeInsets.only(top: 100),
                  constraints: BoxConstraints.expand(height:250),
                  child: ListView(
                    padding: EdgeInsets.only(left: 30), 
                    scrollDirection: Axis.horizontal,
                    
                    children: getRecentJobs()
                  ),
                ),
                SingleChildScrollView(

                ),
                Container(
                  height: 500,
                  margin: EdgeInsets.only(top: 300),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        child: Text(
                          "Projets",
                          style: titileStyleBlack, 
                          ),
                      ),
                      Container(
                        height: 397,
                        child: ListView(
                          children: getJobCategories(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
  List<String> jobCategories = ["Sales", "Engineering", "Health", "Education"];

  Map jobCatToIcon = {
    "Sales" : Icon(Icons.monetization_on, color: lightBlueIsh, size: 10,),
    "Engineering" : Icon(Icons.settings, color: lightBlueIsh, size: 40),
    "Health" : Icon(Icons.healing, color: lightBlueIsh, size: 40),
    "Education" : Icon(Icons.search, color: lightBlueIsh, size: 40),
    
  };

  Widget getCategoryContainer(String categoryName) {
    return new SizedBox(
                height: 115,
                width: 110,
                /* :  
                EdgeInsets.symmetric(vertical: 10), */
                
                child: Card(
                  /*  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15), */
                  shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ), 
                  /* color: Color(0xfffaf5f5), */
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding:EdgeInsets.only(top:5),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.05,
                        /* color: Colors.white, */
                        
                        child: Column(
                          /* mainAxisAlignment: MainAxisAlignment.center, */
                          children: <Widget>[
                            Text(
                              'En cours',
                              style: TextStyle(
                                fontFamily: 'Karla',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff54c19f),
                              ),
                            ),
                            /* Text(
                              '/100',
                              style: TextStyle(
                                fontFamily: 'Karla',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff75777d),
                              ),
                            ), */
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center, 
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 7),
                        child: Text("100",style:TextStyle(fontSize:20,fontWeight:FontWeight.bold))
                      ),
                    ],
                  ),
                ),
              );/* Container(
          margin: EdgeInsets.only(right: 10, left: 10, bottom: 20),
          height: 150,
          width: 140,
          /* padding: EdgeInsets.all(0), */
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              new BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Column(
            
            children: <Widget>[
             Padding(
               padding: EdgeInsets.only(top:0, bottom:0),
               child:Text(categoryName, style: TextStyle(height: 5, fontSize: 10),),
              ),
              Container(
                
                /* padding: EdgeInsets.only(top: 0), */
                height: 100,
                width: 70,
                
                child: Text(
                   "10",
                   style: TextStyle(height:5,fontSize:20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                ),
              ) */
            /* ],
          ),
        ); */
  }

  List<Widget> getJobCategories() {
    List<Widget> jobCategoriesCards = [];
    List<Widget> rows = [];
    int i = 0;
    for (String category in jobCategories) {
      if (i < 2) {
        rows.add(getCategoryContainer(category));
        i ++;
      } else {
        i = 0;
        jobCategoriesCards.add(new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rows,
        ));
        rows = [];
        rows.add(getCategoryContainer(category));
        i++;
      }
    }
    if (rows.length > 0) {
      jobCategoriesCards.add(new Row(
        mainAxisAlignment: MainAxisAlignment.center,
          children: rows,
        ));
    }
    return jobCategoriesCards;
  }

  List<Job> findJobs() {
    List<Job> jobs = [];
    for (int i = 0; i < 1; i++) {
      jobs.add(new Job("Volvo", "Frontend Developer", 20000, "Remote", "Part time", new AssetImage("images/volvo.png")));
    }
    return jobs;
  }

  String makeSalaryToK(double salary) {
    String money = "";
    if (salary > 1000) {
      if (salary > 100000000) {
        salary = salary/100000000;
        money = salary.toInt().toString() + "M";
      } else {
        salary = salary/1000;
        money = salary.toInt().toString() + "K";
      }
    } else {
      money = salary.toInt().toString();
    }
    return "\$" + money;
  }

  List<Widget> getRecentJobs() {
    List<Widget> recentJobCards = [];
    List<Job> jobs = findJobs();
    for (Job job in jobs) {
      recentJobCards.add(getJobCard(job));
    }
    return recentJobCards;
  }

  Widget getJobCard(Job job) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 20, bottom: 30, top: 30),
      height: 300,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          new BoxShadow(
            color: Colors.grey,
            blurRadius: 20.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: job.companyLogo,
              ),
              Text(
                job.jobTitle,
                style: jobCardTitileStyleBlue,
              )
            ],
          ),
          Text(job.companyName + " - " + job.timeRequirement, style: jobCardTitileStyleBlack),
          Text(job.location),
          Text(makeSalaryToK(job.salary), style: salaryStyle)
        ],
      ),
    );
  }
}

