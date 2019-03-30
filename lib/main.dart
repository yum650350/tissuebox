import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flame/game.dart';
import 'dart:math';
main()async{
 var u=Util();
 await u.fullScreen();
 await u.setOrientation(DeviceOrientation.portraitUp);
 Flame.audio.loadAll(['ts1','ts2','ts3','ba','tk']);
 Flame.images.loadAll(['bg1','tb1','tb2','ts1']);
 var g=G((await SharedPreferences.getInstance()).getInt('hs')??0);
 var h=HorizontalDragGestureRecognizer();
 var v=VerticalDragGestureRecognizer();
 h.onUpdate=g.du;
 v.onUpdate=g.du;
 h.onStart=g.ds;
 v.onStart=g.ds;
 h.onEnd=g.de;
 v.onEnd=g.de;
 runApp(g.widget);
 u.addGestureRecognizer(h);
 u.addGestureRecognizer(v);
}
enum Dg{tissue,box,none}
class G extends Game{
 var bg=Sprite('bg1');
 var ip=Offset.zero;
 var dp=Offset.zero;
 Dg m=Dg.none;
 final e=true;
 var og=false;
 var o=false;
 var pa=0.0;
 double ts;
 double sx;
 int h=0;
 int s=0;
 int l=0;
 Size sS;
 Rect r;
 TB b;
 init()async{
  resize(await Flame.util.initialDimensions());
  r=Rect.fromLTWH(0,sS.height-ts*23,ts*9,ts*23);
  b=TB(this);
 }
 sh()async=>await(await SharedPreferences.getInstance()).setInt('hs',h); 
 G(this.h){init();}
 @override
 render(c){
  var k=sS.width/5/ts;
  tx(s,o,f){
   var tp=TextPainter(text:TextSpan(style:TextStyle(color:Colors.black,fontSize:f),text:s),textScaleFactor:k,textDirection:TextDirection.ltr);
   tp.layout();
   tp.paint(c,Offset(o.dx-tp.width/2,o.dy));
  }
  bg.renderRect(c,r);
  b.render(c);
  var ct=b.il+b.r.width/2;
  if(og)tx(pa.toStringAsFixed(pa<1?1:0),Offset(ct,b.it+b.r.height+10),20.0);
  tx(h.toString(),Offset(ct,k*10),20.0);
  tx(s.toString(),Offset(ct,k*50),20.0);
  h=s>h?s:h;
 }
 @override
 update(t){
  b.update(t);
  pa-=og||o?t:0;
  if(pa<0&&og){
   b.a=e;
   og=!e;
   o=e;
   pa=2;
   sh();
   b.nG();
  }else if(og&&!o){
   var v=pa.floor();
   if(v<l&&v<6&&v!=0)Flame.audio.play('tk',volume:0.3);
   l=v;
  }
  o=pa<=0&&o?!e:o;
 }
 resize(s){
  sS=s;
  ts=sS.width/9;
 }
 ds(d){
  var p=d.globalPosition;
  m=b.ti.r.contains(p)?Dg.tissue:b.r.contains(p)?Dg.box:Dg.none;
  ip=Offset(p.dx==0?ip.dx:p.dx,p.dy==0?ip.dy:p.dy);
  sx=(b.ti.r.left-p.dx).abs();
 }
 du(d){
  if(o||m==Dg.none)return;
  var p=d.globalPosition;
  dp=Offset(p.dx==0?dp.dx:p.dx,p.dy==0?dp.dy:p.dy);
  if(m==Dg.tissue){
   if(ip.dy-dp.dy>100){
    if(og!=e&&o!=e){
     og=e;
     pa=10;
     s=0;
    }
    var st=(sx-(b.ti.r.left-p.dx).abs()).abs();
    var sa=st<3?3:st<6?2:1;
    m=Dg.none;
    b.nT(sa);
    t(sa);
    s+=sa;
   }
  }else if(m==Dg.box){
   b.r=Rect.fromLTWH(b.il+dp.dx-ip.dx,b.r.top,TB.w,TB.h);
   b.m=e;
  }
 }
 t(i)=>Flame.audio.play('ts$i',volume:0.2);
 de(d){
  ip=Offset.zero;
  b.ti.m=!e;
  b.m=!e;
  m=Dg.none;
  dp=ip;
 }
}
class TB{
 Rect get ir=>Rect.fromLTWH(r.center.dx-T.w/2,r.top-r.height+7,T.w,T.h);
 Offset get u=>Offset(ir.left,ir.top-200);
 double get it=>g.sS.height-g.ts*5.5;
 double get il=>g.sS.width/2-TB.w/2;
 static var w=150.0;
 static var h=100.0;
 var l=List<TA>();
 var y=Random();
 var m=false;
 var a=false;
 final G g;
 Sprite b;
 Rect r;
 int tc;
 T ti;
 Sprite get gb=>y.nextInt(10)%2==0?Sprite('tb1'):Sprite('tb2');
 TB(this.g){
  r=Rect.fromLTWH(il,it,TB.w,TB.h);
  tc=10-y.nextInt(5);
  ti=T(g,this);
  b=gb;
 }
 render(c){
  b.renderRect(c,r);
  ti.rd(c);
  l.forEach((x)=>x.rd(c));
 }
 update(t){
  ti.ud(t);
  l.removeWhere((x)=>x.a);
  l.forEach((x)=>x.ud(t));
  var v=(r.left-il);
  if(m&&!g.o){
   if(v.abs()>50&&tc==0)a=g.e;
  }else if(a&&!g.o){
   r=r.shift(Offset(v>0?r.left+20:r.left-20,r.top));
   if((r.right<-50||r.left>g.sS.width+50))nB();
  }else if(a&&g.o){
   var o=Offset(r.left,g.sS.height+T.h)-Offset(r.left,r.top);
   r=r.shift((20<o.distance)?Offset.fromDirection(o.direction,20):o);
  }else{
   var o=Offset(il,it)-Offset(r.left,r.top);
   r=r.shift((20<o.distance)?Offset.fromDirection(o.direction,20):o);
  }
 }
 nT(i){
  var d=Duration(milliseconds: 100);
  l.add(TA(g,this));
  if(i>1)Future.delayed(d,(){l.add(TA(g,this));
  if(i>2)Future.delayed(d,(){l.add(TA(g,this));});});
  ti=T(g,this,--tc==0);
 }
 nB(){
  b=gb;
  r=Rect.fromLTWH((r.right<-50)?g.sS.width+50:-50,it,TB.w,TB.h);
  tc=10-y.nextInt(5);
  ti=T(g,this);
  a=!g.e;
  m=!g.e;
 }
 nG()async{
  a=g.e;
  Flame.audio.play('ba',volume:0.3);
  await Future.delayed(Duration(milliseconds:2000));
  nB();
 }
} 
class T{
 var s=Sprite('ts1');
 static var h=100.0;
 static var w=100.0;
 var m=false;
 final TB b;
 final G g;
 bool a;
 Rect r;
 T(this.g,this.b,[this.a=false]){r=b.ir;}
 rd(c)=>s.renderRect(c,r);
 ud(t)=>r=a?r.shift(Offset(-500,-500)):b.ir;
} 
class TA extends T{
 TA(G g,TB b):super(g,b);
 rd(c)=>s.renderRect(c,r);
 ud(t){
  var s=500*t;
  Offset o=b.u-Offset(r.left,r.top);
  if(s<o.distance)r=r.shift(Offset.fromDirection(o.direction,s));else a=g.e;
 }
}