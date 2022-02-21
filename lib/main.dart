import 'package:flutter/material.dart';
import 'package:my_currency_converter/services/Api_Client.dart';
import 'package:my_currency_converter/widget/DropDownWidget.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
  List<String> currencies=[];     //to store currencies
  late String from='';          //dropdown from string
  late String to='';            //dropdown to string

  late double rate; //get rate from api
  String result='';  //show result

  var usd_bdt;  //this is default curriencies

  String date = DateFormat('yyyy-MM-dd'). format(DateTime.now()); //date for search current date rate
  String time = DateFormat('hh:mm a').format(DateTime.now());    //current time for show


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
  }   //it's create container for numbers


  ///from and to text style
  TextStyle pre_txt_style=TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 28);
  TextStyle suf_txt_style=TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 40);

  //which is click? it's test by this 2 variables
  bool pre_is_click=true;
  bool suf_is_click=false;

  void set_zero(){
    if(pre_is_click==true){
      f='0';
      t='0';
    }
    if(suf_is_click==true){
      f='0';
      t='0';
    }
  }


  //set from and to text
  String f='0';
  String t='0';

  void set_number(s)async{
    if(pre_is_click==true){
      if(f.length==15){

      }
      else{
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

    }


    if(suf_is_click==true){
      if(t.length==15){

      }
      else{
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
    }
    await getresult();
  } //when we click any number it's set this from or to text field

  Api_client client=Api_client(); //api_client in services

  Future<List<String>> getCurrencyList() async{ //get currencylist from api client
    return await client.getCurrensies();
  }

  Future<void> getcurrentRate_default() async{ //get current rate USD_BDT
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
  }  //get current rate by from and to dropdown value


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    (() async{
      List<String> list=await getCurrencyList();  //store list of currency
      await getcurrentRate_default();  //to set default currency rate
      setState((){
        date = DateFormat('yyyy-MM-dd'). format(DateTime.now());  //set date when change interface
        time = DateFormat('hh:mm a').format(DateTime.now());  //set itme when change interface
        currencies= list;   //pass list to currencies
        from=currencies[8];  //from dropdown  default item USD
        to=currencies[119];  //to dropDown default item BDT
      });
    })();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mainColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if(constraints.maxWidth>600){
              return Web_Screen();      //when screen horizotal or web mode or
            }
            else{
              return Mobile_Screen(); //when screen default or vertical
            }
          },
        ),
      )
    );
  }


  Widget Mobile_Screen(){   //widget for mobile screen
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16,right: 16,top: 18),
          child: Container(
            width: 200,
            child: AutoSizeText(
              'Currency \nConverter',
              maxLines: 2,
              presetFontSizes: [66,56,46,36,26],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
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
                          child: InkWell(     //when click from text, its change his value
                            splashColor: mainColor,
                            highlightColor: mainColor,
                            onTap: (){
                              setState(() {
                                pre_is_click=true;
                                suf_is_click=false;
                                //set_zero();

                              });
                            },
                            child: AutoSizeText(
                              f,
                              maxLines: 1,
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
                  }),  //dropdown list for from currencies
                  Row(
                    children: [
                      Text("\$",style: TextStyle(color: Colors.white),),
                      SizedBox(width: 12,),
                      Expanded(
                          child: InkWell(
                            splashColor: mainColor,
                            highlightColor: mainColor,
                            onTap: (){   //when click to text, its change his value
                              setState(() {
                                pre_is_click=false;
                                suf_is_click=true;
                                //set_zero();
                              });
                            },
                            child: AutoSizeText(
                              t,
                              maxLines: 1,
                              style: suf_is_click?suf_txt_style:pre_txt_style,
                            )
                          )
                      ),
                    ],
                  ),
                  CustomDropDown(currencies, to, (val){
                    setState((){ //
                      to=val;
                      setState(() async{
                        await getresult();
                      });
                    });
                  }),//dropdown list for to currencies
                  SizedBox(height: 12,),
                  //set default USD_BDT rate
                  AutoSizeText('1 USD = $usd_bdt BDT',style: TextStyle(color: Colors.grey),maxLines: 1,maxFontSize: 26,minFontSize: 16,),
                  SizedBox(height: 3,),
                  //set current date and time
                  AutoSizeText('Updated ${date} ${time}',style: TextStyle(color: Colors.grey),maxLines: 1,maxFontSize: 18,minFontSize: 12,),
                ],
              ),
            ),
          ),
        ),

        ///container for input number and clear all and minus value
        Column(
          children: [
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
                          });
                        },
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
                          child: mycontainer('4')
                      ),
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
                          child: mycontainer('5')
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                        onTap: (){
                          setState(() {
                            set_number('6');
                          });},
                        borderRadius: BorderRadius.circular(8),
                        child: mycontainer('6')
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
                              set_number('1');
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: mycontainer('1')
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              set_number('2');
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: mycontainer('2')
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                        onTap: (){
                          setState(() {
                            set_number('3');
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: mycontainer('3')
                    ),
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
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: mycontainer('0')
                      ),
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
                        child: mycontainer('.')
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }


  //widget for web screen
  Widget Web_Screen(){
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16,right: 16,top: 18),
                child: Container(
                  child: AutoSizeText(
                    'Currency \nConverter',
                    maxLines: 2,
                    maxFontSize: 60,
                    minFontSize: 30,
                    style: TextStyle(
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
                                  onTap: (){  //when click from text, its change his value
                                    setState(() {
                                      pre_is_click=true;
                                      suf_is_click=false;
                                    });
                                  },
                                  child: AutoSizeText(
                                    f,
                                    maxLines: 1,
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
                        }), //dropdown item list for from currencies
                        Row(
                          children: [
                            Text("\$",style: TextStyle(color: Colors.white),),
                            SizedBox(width: 12,),
                            Expanded(
                                child: InkWell(
                                  splashColor: mainColor,
                                  highlightColor: mainColor,
                                  onTap: (){ //when click to text, its change his value
                                    setState(() {
                                      pre_is_click=false;
                                      suf_is_click=true;
                                    });
                                  },
                                  child: AutoSizeText(
                                    t,
                                    maxLines: 1,
                                    style: suf_is_click?suf_txt_style:pre_txt_style,
                                  )
                                )
                            ),
                          ],
                        ),
                        CustomDropDown(currencies, to, (val){
                          setState((){ //
                            to=val;
                            setState(() async{
                              await getresult();
                            });
                          });
                        }),  //dropdown item list for from currencies
                        SizedBox(height: 12,),
                        //set default USD_BDT rate
                        AutoSizeText('1 USD = $usd_bdt BDT',style: TextStyle(color: Colors.grey),maxLines: 1,maxFontSize: 26,minFontSize: 16,),
                        SizedBox(height: 3,),

                        //set current date and time
                        AutoSizeText('Updated ${date} ${time}',style: TextStyle(color: Colors.grey),maxLines: 1,maxFontSize: 18,minFontSize: 12,),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        ///container for input number , clear text and minus value by 1
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                          });
                        },
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
                          child: mycontainer('5')
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                        onTap: (){
                          setState(() {
                            set_number('6');
                          });},
                        borderRadius: BorderRadius.circular(8),
                        child: mycontainer('6')
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
                              set_number('1');
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: mycontainer('1')
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              set_number('2');
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: mycontainer('2')
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                        onTap: (){
                          setState(() {
                            set_number('3');
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: mycontainer('3')
                    ),
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
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: mycontainer('0')
                      ),
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
                        child: mycontainer('.')
                    ),
                  ),
                ],
              ),
            ),
          ],
          )
        )
      ],
    );
  }
}



