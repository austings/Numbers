//Cd(__DIR__);;
#include "FileBMP.HC"
#include "RGBTensor.HC";

#define DC_NUM	4

CDC *cafe_dc[DC_NUM];
F64 glbl_scale;

U0 DrawIt(CTask *,CDC *dc)
{
  dc->flags|=DCF_TRANSFORMATION;
  Mat4x4Scale(dc->r,glbl_scale);
  GrBlot3(dc,0,0,0,cafe_dc[winmgr.updates%DC_NUM]);
}

U0 InitView(Tensor3D*five,F64 scale)
{
  I64 i;
  glbl_scale=scale;
  for (i=0;i<DC_NUM;i++)
    cafe_dc[i]=BMPTensorRead(five,TRUE);
}

U0 CleanUpView()
{
  I64 i;
  for (i=0;i<DC_NUM;i++)
    DCDel(cafe_dc[i]);
}

U0 BMP24View(U8 *filename,F64 scale=1.0)
{
  Cd(__DIR__);
  if (!FileFind(filename))
    throw('NotFound');
  
  Tensor3D *five = BMPFileToTensor(filename);
  InitView(five,scale);
  SettingsPush; //See $LK,"SettingsPush",A="MN:SettingsPush"$
  AutoComplete;
  WinBorder;
  WinMax;
  DocClear;
    
  Fs->draw_it=&DrawIt;
  GetChar;
  SettingsPop;
  CleanUpView;
}

U0 BMP24ViewTensor(Tensor3D *bmp,F64 scale=1.0)
{  
  InitView(bmp,scale);
  SettingsPush; //See $LK,"SettingsPush",A="MN:SettingsPush"$
  AutoComplete;
  WinBorder;
  WinMax;
  DocClear;
    
  Fs->draw_it=&DrawIt;
  GetChar;
  SettingsPop;
  CleanUpView;
}


//BMP24View("C:/Home/Perceptrons/BMP/cat.0.bmp",1.0);

