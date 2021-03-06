
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventell/shared/models/user.dart';
import 'package:eventell/shared/router.dart';
import 'package:eventell/shared/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'CustomSmallButton.dart';

class ListEvent extends StatelessWidget {

  final bool isDetailTicket, isDetailEvent, isShowPaidButton;

  const ListEvent({Key key, this.isDetailTicket, this.isDetailEvent, this.isShowPaidButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    DocumentSnapshot snapshotUser = Provider.of<DocumentSnapshot>(context);
    QuerySnapshot snapshot = Provider.of<QuerySnapshot>(context);

    if(snapshot == null || snapshotUser == null ){
      return Center(child: SpinKitCubeGrid(color: Coloring.colorMain,));
    }

    if(snapshot.documents.isEmpty){
      return Center(child: Text("No data!"));
    }

    List<DocumentSnapshot> _snapshotData = snapshot.documents.reversed.toList();
    User _user = User.fromMap(snapshotUser.data);
    return Padding(
      padding: const EdgeInsets.only(
          left: Sizing.paddingContent, right: Sizing.paddingContent),
      child: ListView.separated(
        itemCount: _snapshotData.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          var data = this.isDetailTicket
              ? _snapshotData[index].data['event']:_snapshotData[index].data;
          return GestureDetector(
            onTap: (){
              if(this.isDetailEvent)
                Navigator.of(context).pushNamed(Router.detailevent, arguments: {
                  'dataEvent':data,
                  'dataUser': _user});

              if(this.isDetailTicket)
                Navigator.of(context).pushNamed(Router.detailticket, arguments: {
                  'dataEventTicket':_snapshotData[index].data,
                  'dataUser': _user});
            },
            child: Card(
              elevation: 8,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 150,
                      imageUrl: data['eventImage'],
                      placeholder: (context, url) =>
                          SpinKitDoubleBounce(color: Coloring.colorMain,),
                      errorWidget: (context, url, error) =>
                      new Icon(Icons.error),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(data['eventName'],
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                            Divider(height: 15,),
                            Text(FlutterMoneyFormatter(
                                amount: data['eventPrice'].toDouble(),
                                settings: MoneyFormatterSettings(
                                  symbol: 'Rp. ',
                                  thousandSeparator: '.',
                                  decimalSeparator: ',',
                                  symbolAndNumberSeparator: ' ',
                                  fractionDigits: 2,
                                )
                            ).output.symbolOnLeft,
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                            Divider(height: 5,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(MdiIcons.clockOutline, size: 13.0, color: Coloring.colorMain,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(data['eventDate'] + "\n" + data['eventTime'],
                                      style: TextStyle(fontSize: 13.0)),
                                ),
                              ],
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.location_on, size: 13.0, color: Coloring.colorMain,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.45,
                                    child: Text(data['eventAddress'],
                                        style: TextStyle(fontSize: 13.0)),
                                  ),
                                )
                              ],
                            ),
                            isShowPaidButton ? CustomSmallButton(
                              color: Colors.blue[100],
                              textColor: Colors.black87,
                              label: 'Upload Bukti',
                              onPressed: (){

                              },
                            ) : Divider()
                          ],
                        ),
                      )),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          if ((index % 3) == 0 && index != 0)
            return SizedBox(
              height: 50,
              child: Card(
                color: Colors.redAccent,
                elevation: 8,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Text('Iklan ' + index.toString())],
                  ),
                ),
              ),
            );
          else
            return SizedBox();
        },
      ),
    );
  }
}