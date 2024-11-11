unit ProXML.Classes;

interface

type

TConfig = class(TObject)

private
    FEmail: String;
    FSenha: String;
    FSMTP: String;
    FSSL: Boolean;
    FTSL: Boolean;
    FPorta: String;
    FMensagem: String;

public

   //class var FInstance : TConfig;
   property SMTP: String read FSMTP write FSMTP;
   property Email: String read FEmail write FEmail;
   property Senha: String read FSenha write FSenha;
   property Porta: String read FPorta write FPorta;
   property SSL: Boolean read FSSL write FSSL;
   property TSL: Boolean read FTSL write FTSL;
   property Mensagem: String read FMensagem write FMensagem;

   constructor Create();  // Construtor
   destructor Destroy; override; // Destrutor
end;

implementation

uses
  System.SysUtils;

{ TConfig }

constructor TConfig.Create;
begin
   SSL := False;
   TSL := False;
end;

destructor TConfig.Destroy;
begin

  inherited;
end;

end.
