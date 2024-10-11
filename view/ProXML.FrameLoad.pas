unit ProXML.FrameLoad;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Skia,
  Skia.Vcl;

type
  TFrameLoad = class(TFrame)
    Panel1: TPanel;
    SkAnimatedImage1: TSkAnimatedImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
