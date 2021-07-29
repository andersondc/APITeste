unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls, System.Math,
  Vcl.Imaging.pngimage, Vcl.Grids, Vcl.Imaging.jpeg, Rest.Client,REST.Types,System.JSON,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, REST.Json,Clipbrd,
  Vcl.Samples.Gauges, System.Notification;

type
  TFPrincipal = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Pags: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Panel4: TPanel;
    vBody: TMemo;
    Fundo: TImage;
    PDadosAPI: TPanel;
    Panel6: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    vURL: TEdit;
    Label3: TLabel;
    vResource: TEdit;
    Panel7: TPanel;
    BExec: TButton;
    BNovo: TButton;
    BToken: TButton;
    BBody: TButton;
    Label4: TLabel;
    vMetodo: TComboBox;
    Label5: TLabel;
    vTimeOut: TComboBox;
    Panel8: TPanel;
    GridParametros: TStringGrid;
    Label6: TLabel;
    BAut: TButton;
    TabSheet5: TTabSheet;
    vToken: TMemo;
    BAdd: TButton;
    BRemove: TButton;
    Panel10: TPanel;
    Label7: TLabel;
    Button8: TButton;
    Panel9: TPanel;
    Panel11: TPanel;
    Label8: TLabel;
    Button9: TButton;
    Panel5: TPanel;
    Panel12: TPanel;
    Label9: TLabel;
    vBea: TCheckBox;
    Button10: TButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image5: TImage;
    Image6: TImage;
    vResp: TMemo;
    bJon: TButton;
    Status: TLabel;
    Image4: TImage;
    PAguarde: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Salva: TSaveDialog;
    NotificationCenter1: TNotificationCenter;
    Panel13: TPanel;
    aToken: TLabel;
    aBody: TLabel;
    Timer1: TTimer;
    vBuscar: TEdit;
    bBuscar: TButton;
    Label13: TLabel;
    procedure Image5Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure BAddClick(Sender: TObject);
    procedure BRemoveClick(Sender: TObject);
    procedure BAutClick(Sender: TObject);
    procedure BTokenClick(Sender: TObject);
    procedure BBodyClick(Sender: TObject);
    procedure BExecClick(Sender: TObject);
    procedure bJonClick(Sender: TObject);
    procedure BNovoClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure bBuscarClick(Sender: TObject);
    procedure vBuscarKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    procedure APIExec;
    function VerificaSeTemAuth: integer;
    function FormatJSON(vjson: String): String;
    procedure IniciaTempo;
    procedure Notificacao(texto: string);
    procedure BuscarPalavra(texto: string);
    procedure ScrollMemo(Memo: TMemo; Direction: Integer);
  end;

var
  FPrincipal: TFPrincipal;
  FSelPos: integer;

implementation

{$R *.dfm}

procedure TFPrincipal.BAddClick(Sender: TObject);
begin
  GridParametros.RowCount:=GridParametros.RowCount+1;
end;

procedure TFPrincipal.BAutClick(Sender: TObject);
begin
  if GridParametros.Cells[0,GridParametros.RowCount-1]<>'' then
    GridParametros.RowCount:=GridParametros.RowCount+1;

  GridParametros.Cells[0,GridParametros.RowCount-1]:='Authorization';
  GridParametros.Cells[1,GridParametros.RowCount-1]:='token';
end;

procedure TFPrincipal.BBodyClick(Sender: TObject);
begin
  Pags.ActivePageIndex:=2;
end;

procedure TFPrincipal.BExecClick(Sender: TObject);
begin
  vResp.Clear;

  Status.Caption:='Executando API: '+vURL.Text+vResource.Text+' Método: '+vMetodo.Text;
  Status.Repaint;

  Application.ProcessMessages;

  APIExec;

  PAguarde.Visible:=false;
end;

procedure TFPrincipal.BNovoClick(Sender: TObject);
begin
  Status.Caption:='API Test';
  vURL.Clear;
  vResource.Clear;
  GridParametros.RowCount:=1;
  GridParametros.Cells[0,0]:='';
  GridParametros.Cells[1,0]:='';
  vTimeOut.Text:='1000';
  vMetodo.ItemIndex:=0;
end;

procedure TFPrincipal.BRemoveClick(Sender: TObject);
begin
  if GridParametros.RowCount>1 then
    GridParametros.RowCount:=GridParametros.RowCount-1;
end;

procedure TFPrincipal.BTokenClick(Sender: TObject);
begin
  Pags.ActivePageIndex:=3;
end;

procedure TFPrincipal.Button10Click(Sender: TObject);
begin
  Clipboard.AsText:=vResp.Text;
  Notificacao('Resposta Salva na Área de Transferência!');
end;

procedure TFPrincipal.bBuscarClick(Sender: TObject);
begin
  BuscarPalavra(vBuscar.Text);
end;

procedure TFPrincipal.Button8Click(Sender: TObject);
begin
  vBody.Text:='{"<campo_1>":"<valor_1>","<campo_2>":"<valor_2>","<campo_3>":"<valor_3>"}';
  vBody.Text:=formatJSON(vBody.Text);
end;

procedure TFPrincipal.Button9Click(Sender: TObject);
begin
  Salva.Execute;

  vResp.Lines.SaveToFile(Salva.FileName);

  Notificacao('Resposta Salva com Sucesso!');
end;

procedure TFPrincipal.bJonClick(Sender: TObject);
begin
  Status.Caption:='Verificando Formatação...';
  Status.Repaint;

  Application.ProcessMessages;

  try
    vResp.Text:=FormatJSON(vResp.Text);
  except
    Status.Caption:='Resposta Não é JSON para Efetuar Formatação!';
    Status.Repaint;
    Notificacao('Resposta Não é JSON para Efetuar Formatação!');
    exit;
  end;

  Notificacao('Resposta Formatada como JSON!');
end;

procedure TFPrincipal.Notificacao(texto: string);
var
  MyNotification: TNotification;
begin
  MyNotification := NotificationCenter1.CreateNotification;
  try
    MyNotification.Name:='APITest';
    MyNotification.Title:='Sistema de Testes para Consumo de API';
    MyNotification.AlertBody:=texto;

    NotificationCenter1.PresentNotification(MyNotification);
  finally
    MyNotification.Free;
  end;
end;

procedure TFPrincipal.Timer1Timer(Sender: TObject);
begin
  if Length(trim(vBody.Text))>0 then
    aBody.Visible:=true
  else
    aBody.Visible:=false;

  if Length(trim(vToken.Text))>0 then
    aToken.Visible:=true
  else
    aToken.Visible:=false;

end;

procedure TFPrincipal.vBuscarKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    bBuscar.Click;
  end;
end;

procedure TFPrincipal.BuscarPalavra(texto: string);
var
  S : string;
  Startpos : integer;
begin
  if FSelPos = 0 then
     StartPos := FSelPos + Length(texto);
  S := Copy(vResp.Lines.Text, StartPos, MaxInt);
  S := vResp.Lines.Text;
  StartPos := 1;
  FSelPos := Pos(texto, S);
  if FSelPos > 0 then
  begin
    FSelPos := FSelPos + StartPos - 1;
    vResp.SelStart := FSelPos - 1;
    ScrollMemo(vResp, SB_LINEDOWN);
    vResp.SelLength := Length(texto);
    vResp.SetFocus;
  end;
end;

procedure TFPrincipal.ScrollMemo(Memo: TMemo; Direction: Integer);
var
  ScrollMessage: TWMVScroll;
  I: Integer;
begin
  ScrollMessage.Msg := WM_VSCROLL;
  Memo.Lines.BeginUpdate;
  try
    for I := 0 to Memo.Lines.Count do
    begin
     ScrollMessage.ScrollCode := Direction;
     ScrollMessage.Pos := 0;
     Memo.Dispatch(ScrollMessage);
    end;
  finally
    Memo.Lines.EndUpdate;
  end;
end;

procedure TFPrincipal.APIExec;
var
  RESTClient1: TRESTClient;
  RESTRequest1: TRESTRequest;
  strImageJSON : string;

  jsob, jsonob: TJSONObject;
  JSValue: TJSONValue;
  JSONArray: TJSONArray;
  JSONArray1: TJSONArray;
  jPar: TJSONPair;

  i: integer;
  auxStr: string;

  content: string;
  auxLib: integer;

  BodyStr: string;

  xToken: string;
begin
  IniciaTempo;

  // Recupera dominio da API
  RESTClient1 := TRESTClient.Create(vURL.Text);
  RESTRequest1 := TRESTRequest.Create(nil);

  try
    // Recupera Metodo
    case vMetodo.ItemIndex of
      0: RESTRequest1.Method:=TRESTRequestMethod.rmPOST;
      1: RESTRequest1.Method:=TRESTRequestMethod.rmGET;
      2: RESTRequest1.Method:=TRESTRequestMethod.rmPUT;
      3: RESTRequest1.Method:=TRESTRequestMethod.rmDELETE;
      4: RESTRequest1.Method:=TRESTRequestMethod.rmPATCH;
    end;

    // Recupera Resource
    if vResource.Text<>'' then
      RESTRequest1.Resource:=trim(vResource.Text);

    // Recupera Authorization
    if VerificaSeTemAuth>-1 then
    begin
      if gridParametros.Cells[1,VerificaSeTemAuth]='token' then
      begin
        if vBea.Checked then
          xToken:='Bearer '+vtoken.Lines.Text
        else
          xToken:=vtoken.Lines.Text;
      end
      else
        xToken:=gridParametros.Cells[1,VerificaSeTemAuth];

      RESTRequest1.AddAuthParameter('Authorization',
                   xToken,
                   TRESTRequestParameterKind.pkHTTPHEADER,
                   [TRESTRequestParameterOption.poDoNotEncode]);
    end;

    // Recupera Parametros
    for i:=0 to gridParametros.RowCount-1 do
    begin
      if (GridParametros.Cells[0,i]<>'Authorization') and
         (length(GridParametros.Cells[0,i])>0) then
        RESTRequest1.AddParameter(GridParametros.Cells[0,i],
                                  GridParametros.Cells[1,i]);
    end;

    // Recupera Body
    if Length(vBody.Text)>0 then
      RESTRequest1.Params.AddItem('body',vBody.Text,
                          TRESTRequestParameterKind.pkREQUESTBODY,[],
                          ctAPPLICATION_JSON);

    // Define Client
    RESTRequest1.Client := RESTClient1;

    // Recupera TimeOut
    RESTRequest1.Timeout:=StrTOInt(vTimeOut.Text);

    // Executa API
    RESTRequest1.Execute;

    strImageJSON := RESTRequest1.Response.Content;
  finally
    RESTRequest1.Free;
  end;

  Status.Caption:='API Executada!';
  Status.Repaint;

  Notificacao('API Executada!');

  Application.ProcessMessages;

  Pags.ActivePageIndex:=4;
  vResp.Lines.Text:=strImageJSON;
  bJon.Click;
end;

function TFPrincipal.VerificaSeTemAuth: integer;
var
  i: integer;
  l: integer;
begin
  l:=-1;

  for i:=0 to GridParametros.RowCount-1 do
  begin
    if GridParametros.Cells[0,i]='Authorization' then
      l:=i;
  end;

  result:=l;
end;

procedure TFPrincipal.Image2Click(Sender: TObject);
begin
  Pags.ActivePageIndex:=4;
end;

procedure TFPrincipal.Image3Click(Sender: TObject);
begin
  Pags.ActivePageIndex:=3;
end;

procedure TFPrincipal.Image4Click(Sender: TObject);
begin
  Pags.ActivePageIndex:=2;
end;

procedure TFPrincipal.Image5Click(Sender: TObject);
begin
  Pags.ActivePageIndex:=1;
end;

procedure TFPrincipal.IniciaTempo;
begin
  PAguarde.Top:=trunc(screen.Height/2)-trunc(PAguarde.Height/2);
  PAguarde.Left:=trunc(screen.Width/2)-trunc(PAguarde.Width/2);
  PAguarde.Visible:=true;
  Application.ProcessMessages;
end;

function TFPrincipal.FormatJSON(vjson: String): String;
var
  tmpJson: TJsonObject;
begin
  tmpJson := TJSONObject.ParseJSONValue(vjson) as TJSONObject;
  Result := TJson.Format(tmpJson);

  Status.Caption:='JSON Formatado!';
  Status.Repaint;

  FreeAndNil(tmpJson);
end;

procedure TFPrincipal.FormShow(Sender: TObject);
begin
  Pags.ActivePageIndex:=0;
end;

end.
