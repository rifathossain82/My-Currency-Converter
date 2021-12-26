import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:my_currency_converter/services/Api_Client.dart';
import 'package:my_currency_converter/widget/DropDownWidget.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        theme: ThemeData(primaryColor: Color(0xFF212936),),
        title: 'Currency Converter',
        debugShowCheckedModeBanner: false,
        home: Homepage(),
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //TextEditingController controller=TextEditingController(); //to store the text which is given by user
  bool hasInternet=false;    //a variable to store bool value by depend on internet connectivity


  Color mainColor = Color(0xFF212936);
  Color secondColor = Color(0xFF2849E5);
  List<String> currencies=[];
  late String from='';
  late String to='';

  late double rate;
  String result='';


  var usd_bdt;

  String date = DateFormat('yyyy-MM-dd'). format(DateTime.now());
  String time = DateFormat('hh:mm a').format(DateTime.now());


  Widget mycontainer(String txt){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      height: 50,
      alignment: Alignment.center,
      child: Text(txt,style: TextStyle(color: Colors.white,fontSize: 18),),
    );
  }

  TextStyle pre_txt_style=TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 28);
  TextStyle suf_txt_style=TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 40);
  bool pre_is_click=true;
  bool suf_is_click=false;

  String f='0';
  String t='0';

  void set_number(s)async{
    if(pre_is_click==true){
      if(f.contains('.')){
        f=f+s;
      }
      else{
        double n=double.parse(f);
        if(n==0.0){
          f=f.replaceFirst('0', s);
        }
        else{
          f=f+s;
        }
      }

    }
    if(suf_is_click==true){
      if(t.contains('.')){
        t=t+s;
      }
      else{
        double n=double.parse(t);
        if(n==0.0){
          t=t.replaceFirst('0', s);
        }
        else{
          t=t+s;
        }
      }
    }
    await getresult();
  }

  Api_client client=Api_client();

  Future<List<String>> getCurrencyList() async{
    return await client.getCurrensies();
  }

  Future<void> getcurrentRate_default() async{
    usd_bdt= await client.getcurrentRate_Default(date);
  }


  Future<void> getresult()async{
    if(pre_is_click==true){
      setState(() async{
        rate=await client.getRate(from, to);
        setState(() {
          t=(rate*double.parse(f)).toStringAsFixed(3);
        });
      });
    }
    if(suf_is_click==true){
      setState(() async{
        rate=await client.getRate(to, from);
        setState(() {
          f=(rate*double.parse(t)).toStringAsFixed(3);
        });
      });
    }
  }


  // final Uri currency_api=Uri.https("free.currconv.com","/api/v7/currencies", {"apiKey":"0a887d855a68b6afb8a6"});
  // // final response=await http.get(Uri.parse("https://jsonplaceholder.typicode.com/comments"));
  // //   final response= await http.get(Uri.parse('https://free.currconv.com/api/v7/currencies?apiKey=0a887d855a68b6afb8a6'));
  // Future<List<String>> getCurrensies() async{
  //   final response= await http.get(currency_api);
  //   if(response.statusCode==200){
  //     var body=jsonDecode(response.body);
  //     var list=body['results'];
  //     List<String> currensies=(list.keys).toList();
  //     print(currensies);
  //     return currensies;
  //   }
  //   else{
  //     throw Exception('Failed to connect to API.');
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    (() async{
      List<String> list=await getCurrencyList();
      await getcurrentRate_default();
      setState((){
        date = DateFormat('yyyy-MM-dd'). format(DateTime.now());
        time = DateFormat('hh:mm a').format(DateTime.now());
        currencies= list;
        from=currencies[8];
        to=currencies[119];
      });
    })();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mainColor,
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16,right: 16,top: 18),
                child: Container(
                  width: 200,
                  child: Text(
                    'Currency Converter',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16,right: 16),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("\$",style: TextStyle(color: Colors.white),),
                              SizedBox(width: 12,),
                              Expanded(
                                  child: InkWell(
                                    splashColor: mainColor,
                                    highlightColor: mainColor,
                                    onTap: (){
                                      setState(() {
                                        pre_is_click=true;
                                        suf_is_click=false;
                                      });
                                    },
                                    child: Text(
                                      f,
                                      style: pre_is_click?suf_txt_style:pre_txt_style,
                                    ),
                                  )
                              ),
                            ],
                          ),
                          CustomDropDown(currencies, from, (val){
                              setState((){ //
                                from=val;
                                setState(() async{
                                  await getresult();
                                });
                              });
                          }),
                          Row(
                            children: [
                              Text("\$",style: TextStyle(color: Colors.white),),
                              SizedBox(width: 12,),
                              Expanded(child: InkWell(
                                  splashColor: mainColor,
                                  highlightColor: mainColor,
                                  onTap: (){
                                    setState(() {
                                      pre_is_click=false;
                                      suf_is_click=true;
                                    });
                                  },
                                  child: Text(
                                    t,
                                    style: suf_is_click?suf_txt_style:pre_txt_style,
                                  ))),
                            ],
                          ),
                          CustomDropDown(currencies, to, (val){
                              setState((){ //
                                to=val;
                                setState(() async{
                                  await getresult();
                                });
                              });
                          }),
                          SizedBox(height: 12,),
                          Text('1 USD = $usd_bdt BDT',style: TextStyle(color: Colors.grey),),
                          SizedBox(height: 3,),
                          Text('Updated ${date} ${time}',style: TextStyle(color: Colors.grey)),

                        ],
                      ),
                    ),
                  ),
              ),

              ///container for input number
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Container(
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: (){
                            setState(() {
                              f='0';
                              t='0';
                            });
                          },
                            child: mycontainer('CE')
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                         setState(() {
                           if(pre_is_click==true){
                             //from text minus
                             if(f.length==1){
                               f='0';
                             }
                             else {
                               f = f.substring(0, f.length - 1);
                             }
                           }
                           else{
                             //to text minus
                             if(t.length==1){
                               t='0';
                             }
                             else {
                               t = t.substring(0, t.length - 1);
                             }
                           }
                         });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          height: 50,
                          alignment: Alignment.center,
                          child: Icon(Icons.backspace_outlined,color: Colors.white,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: InkWell(
                            onTap: (){
                              setState(() {
                                set_number('7');
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: mycontainer('7')
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: InkWell(
                            onTap: (){
                              setState(() {
                                set_number('8');
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: mycontainer('8')
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              set_number('9');
                            });},
                          borderRadius: BorderRadius.circular(8),
                          child: mycontainer('9')
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: InkWell(
                            onTap: (){
                              setState(() {
                                set_number('4');
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: mycontainer('4')),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: InkWell(
                            onTap: (){
                              setState(() {
                                set_number('5');
                              });
                              },
                            borderRadius: BorderRadius.circular(8),
                            child: mycontainer('5')),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              set_number('6');
                            });},
                          borderRadius: BorderRadius.circular(8),
                          child: mycontainer('6')),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: InkWell(
                            onTap: (){
                              setState(() {
                                set_number('1');
                              });},
                            borderRadius: BorderRadius.circular(8),
                            child: mycontainer('1')),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: InkWell(
                            onTap: (){
                              setState(() {
                                set_number('2');
                              });},
                            borderRadius: BorderRadius.circular(8),
                            child: mycontainer('2')),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              set_number('3');
                            });},
                          borderRadius: BorderRadius.circular(8),
                          child: mycontainer('3')),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 2, 4, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Container(
                          color: Colors.white38,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: InkWell(
                            onTap: (){
                              setState(() {
                                set_number('0');
                              });},
                            borderRadius: BorderRadius.circular(8),
                            child: mycontainer('0')),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              if(pre_is_click==true){
                                if(f.contains('.')){

                                }
                                else{
                                  f=f+'.';
                                }
                              }
                              else{
                                if(t.contains('.')){

                                }
                                else{
                                  t=t+'.';
                                }
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: mycontainer('.')),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}


/*
FutureBuilder(
                            future: getCurrensies(),
                            builder: (context,AsyncSnapshot<List<String>> snapshot){
                              if(snapshot.hasData){
                                return CustomDropDown(currencies, from, (val){});
                              }
                              else if(snapshot.hasError){
                                return Center(child: Text("${snapshot.error}"));
                              }
                              else{
                                return Center(child: CircularProgressIndicator());
                              }
                            },
                          )
 */