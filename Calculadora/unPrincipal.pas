unit unPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, unClasseCalculadora,
  unClasseImpostos;

type
  TfrmPrincipal = class(TForm)
    pnlCalculadora: TPanel;
    edtVisor: TEdit;
    btn1: TBitBtn;
    btn2: TBitBtn;
    btn3: TBitBtn;
    btn4: TBitBtn;
    btn5: TBitBtn;
    btn6: TBitBtn;
    btn7: TBitBtn;
    btn8: TBitBtn;
    btn9: TBitBtn;
    btn0: TBitBtn;
    btnSoma: TBitBtn;
    btnSubtracao: TBitBtn;
    btnMultiplicacao: TBitBtn;
    btnDivisao: TBitBtn;
    btnResultado: TBitBtn;
    btnClear: TBitBtn;
    btnClearEntry: TBitBtn;
    grpImpostos: TGroupBox;
    btnImpostoA: TBitBtn;
    edtImpostoA: TEdit;
    btnImpostoB: TBitBtn;
    edtImpostoB: TEdit;
    btnImpostC: TBitBtn;
    edtImpostoC: TEdit;
    btnLimparImpostos: TBitBtn;
    btnSinalDecimal: TBitBtn;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure btn8Click(Sender: TObject);
    procedure btn9Click(Sender: TObject);
    procedure btn0Click(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnClearEntryClick(Sender: TObject);
    procedure btnSomaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnSubtracaoClick(Sender: TObject);
    procedure btnMultiplicacaoClick(Sender: TObject);
    procedure btnDivisaoClick(Sender: TObject);
    procedure btnResultadoClick(Sender: TObject);
    procedure btnLimparImpostosClick(Sender: TObject);
    procedure btnImpostoAClick(Sender: TObject);
    procedure btnImpostoBClick(Sender: TObject);
    procedure btnImpostCClick(Sender: TObject);
    procedure btnSinalDecimalClick(Sender: TObject);
    procedure CalculadoraKeyPress(Sender: TObject; var Key: Char);
  private
    OperacaoSoma: TCalculadora;
    OperacaoSubtracao: TCalculadora;
    OperacaoMultiplicacao: TCalculadora;
    OperacaoDivisao: TCalculadora;
    procedure preencherVisor(cDigito: String);
    procedure DestruirObjetos();

    procedure LimparCamposImpostos();
    procedure CalcularImpostoA();
    procedure CalcularImpostoB();
    procedure CalcularImpostoC();
    procedure AplicarValorTecla(var Key: Char);

    { Private declarations }
  public

    { Public declarations }
  end;

const
  FORMATO_VALOR: string = '###,###,###,###,###,##0.00';

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.btn0Click(Sender: TObject);
begin
  preencherVisor('0');
end;

procedure TfrmPrincipal.btn1Click(Sender: TObject);
begin
  preencherVisor('1');
end;

procedure TfrmPrincipal.btn2Click(Sender: TObject);
begin
  preencherVisor('2');
end;

procedure TfrmPrincipal.btn3Click(Sender: TObject);
begin
  preencherVisor('3');
end;

procedure TfrmPrincipal.btn4Click(Sender: TObject);
begin
  preencherVisor('4');
end;

procedure TfrmPrincipal.btn5Click(Sender: TObject);
begin
  preencherVisor('5');
end;

procedure TfrmPrincipal.btn6Click(Sender: TObject);
begin
  preencherVisor('6');
end;

procedure TfrmPrincipal.btn7Click(Sender: TObject);
begin
  preencherVisor('7');
end;

procedure TfrmPrincipal.btn8Click(Sender: TObject);
begin
  preencherVisor('8');
end;

procedure TfrmPrincipal.btn9Click(Sender: TObject);
begin
  preencherVisor('9');
end;

procedure TfrmPrincipal.btnClearClick(Sender: TObject);
begin
  edtVisor.Text := EmptyStr;
  TCalculadora.operacaoAtiva := tpoNada;
  TCalculadora.nNumeroAnterior := 0;
  TCalculadora.nNumeroAtual := 0;
  DestruirObjetos();
end;

procedure TfrmPrincipal.btnClearEntryClick(Sender: TObject);
begin
  if (edtVisor.Text) <> EmptyStr then
    edtVisor.Text := Copy(edtVisor.Text, 1, Length(edtVisor.Text) - 1);
end;

procedure TfrmPrincipal.btnDivisaoClick(Sender: TObject);
begin
  if (edtVisor.Text = EmptyStr) then
    Exit;

  if not Assigned(OperacaoDivisao) then
  begin
    OperacaoDivisao := TOperacaoDivisao.Create;
    OperacaoDivisao.primeiraVez := True;
  end;

  if not (TCalculadora.operacaoAtiva in [tpoNada, tpoDivisao]) then
    btnResultado.OnClick(btnResultado);

  if (TCalculadora.operacaoAtiva = tpoDivisao) then
  begin
    OperacaoDivisao.nNumeroAnterior := StrToFloat(edtVisor.Text);
    Exit;
  end;
  OperacaoDivisao.nNumeroAtual := StrToFloat(edtVisor.Text);
  edtVisor.Text := OperacaoDivisao.Calculo().ToString;
  OperacaoDivisao.zerar := True;
end;

procedure TfrmPrincipal.btnImpostCClick(Sender: TObject);
begin
  CalcularImpostoC();
end;

procedure TfrmPrincipal.btnImpostoAClick(Sender: TObject);
begin
  CalcularImpostoA();
end;

procedure TfrmPrincipal.btnImpostoBClick(Sender: TObject);
begin
  CalcularImpostoB();
end;

procedure TfrmPrincipal.btnLimparImpostosClick(Sender: TObject);
begin
  LimparCamposImpostos();
end;

procedure TfrmPrincipal.btnMultiplicacaoClick(Sender: TObject);
begin
  if (edtVisor.Text = EmptyStr) then
    Exit;

  if not Assigned(OperacaoMultiplicacao) then
  begin
    OperacaoMultiplicacao := TOperacaoMultiplicacao.Create;
    OperacaoMultiplicacao.primeiraVez := True;
  end;

  if not (TCalculadora.operacaoAtiva in [tpoNada, tpoMultiplicacao]) then
    btnResultado.OnClick(btnResultado);


  if (TCalculadora.operacaoAtiva = tpoMultiplicacao) then
  begin
    OperacaoMultiplicacao.nNumeroAnterior := StrToFloat(edtVisor.Text);
    Exit;
  end;
  OperacaoMultiplicacao.nNumeroAtual := StrToFloat(edtVisor.Text);
  edtVisor.Text := OperacaoMultiplicacao.Calculo().ToString;
  TCalculadora.nNumeroAnterior := TCalculadora.nNumeroAtual;
  OperacaoMultiplicacao.zerar := True;
end;

procedure TfrmPrincipal.btnResultadoClick(Sender: TObject);
begin
  if (edtVisor.Text = EmptyStr) then
    Exit;

  if not (TCalculadora.operacaoAtiva in [tpoNada, tpoSubtracao]) then
    TCalculadora.nNumeroAtual := StrToFloat(edtVisor.Text);

  case TCalculadora.operacaoAtiva of
    tpoSoma:
      begin
        edtVisor.Text := OperacaoSoma.Calculo().ToString;
      end;
    tpoSubtracao:
      begin
        edtVisor.Text := OperacaoSubtracao.Calculo().ToString;
      end;
    tpoMultiplicacao:
      begin
        edtVisor.Text := OperacaoMultiplicacao.Calculo().ToString;
      end;
    tpoDivisao:
      begin
        edtVisor.Text := OperacaoDivisao.Calculo().ToString;
      end;
  end;
  TCalculadora.zerar := True;
end;

procedure TfrmPrincipal.btnSinalDecimalClick(Sender: TObject);
begin
  var strVisor:String := edtVisor.Text;
  if (strVisor.CountChar(',') = 0) then
  begin
    if strVisor.IsEmpty then
      preencherVisor('0,')
    else
      preencherVisor(',');
  end;
end;

procedure TfrmPrincipal.btnSomaClick(Sender: TObject);
begin
  if (edtVisor.Text = EmptyStr) then
    Exit;

  if not Assigned(OperacaoSoma) then
  begin
    OperacaoSoma := TOperacaoSoma.Create;
    OperacaoSoma.primeiraVez := True;
  end;

  if not (TCalculadora.operacaoAtiva in [tpoNada, tpoSoma, tpoSubtracao]) then
    btnResultado.OnClick(btnResultado);

  if (TCalculadora.operacaoAtiva = tpoSoma) then
  begin
    OperacaoSoma.nNumeroAnterior := StrToFloat(edtVisor.Text);
    Exit;
  end;

  OperacaoSoma.nNumeroAtual := StrToFloat(edtVisor.Text);
  edtVisor.Text := OperacaoSoma.Calculo().ToString;
  OperacaoSoma.zerar := True;
end;

procedure TfrmPrincipal.btnSubtracaoClick(Sender: TObject);
begin
  if (edtVisor.Text = EmptyStr) then
    Exit;

  if not Assigned(OperacaoSubtracao) then
  begin
    OperacaoSubtracao := TOperacaoSubtracao.Create;
    OperacaoSubtracao.primeiraVez := True;
  end;

  if (TCalculadora.operacaoAtiva = tpoSubtracao) then
  begin
    Exit;
  end;
  OperacaoSubtracao.nNumeroAtual := StrToFloat(edtVisor.Text);
  edtVisor.Text := OperacaoSubtracao.Calculo().ToString;
  OperacaoSubtracao.zerar := True;
end;

procedure TfrmPrincipal.CalculadoraKeyPress(Sender: TObject; var Key: Char);
begin
  var strVisor: string := edtVisor.Text;

  if not (CharInSet(Key, [#8, #13, '0'..'9', ',', '+', '-', '*', '/'])) or ((CharInSet(key, [','])) and (strVisor.CountChar(',') = 1) ) then
    Key := #0;

  if (CharInSet(Key, ['+'])) then
  begin
    btnSoma.Click;
    Key := #0;
  end;

  if (CharInSet(Key, ['-'])) then
  begin
    btnSubtracao.Click;
    Key := #0;
  end;

  if (CharInSet(Key, ['*'])) then
  begin
    btnMultiplicacao.Click;
    Key := #0;
  end;

  if (CharInSet(Key, ['/'])) then
  begin
    btnDivisao.Click;
    Key := #0;
  end;

  if (CharInSet(Key, [#13])) then
  begin
    btnResultado.Click;
    Key := #0;
  end;

  if (CharInSet(Key, ['0'..'9', ','])) then
  begin
    AplicarValorTecla(Key);
    Key := #0;
  end;

  if edtVisor.CanFocus then
    edtVisor.SetFocus;
  edtVisor.SelStart := Length(edtVisor.Text);
end;

procedure TfrmPrincipal.CalcularImpostoA;
var
  Imposto: TImposto;
begin
  Imposto := TImpostoA.Create;
  try
    edtImpostoA.Text := FormatFloat(FORMATO_VALOR, Imposto.CalculaImposto(StrToFloatDef(edtVisor.Text, 0)));
  finally
    Imposto.Free;
  end;
end;

procedure TfrmPrincipal.CalcularImpostoB;
var
  Imposto: TImposto;
begin
  Imposto := TImpostoB.Create;
  try
    edtImpostoB.Text := FormatFloat(FORMATO_VALOR, Imposto.CalculaImposto(StrToFloatDef(edtVisor.Text, 0)));
  finally
    Imposto.Free;
  end;
end;

procedure TfrmPrincipal.CalcularImpostoC;
var
  Imposto: TImposto;
begin
  Imposto := TImpostoC.Create;
  try

    edtImpostoC.Text := FormatFloat(FORMATO_VALOR, Imposto.CalculaImposto(StrToFloatDef(edtVisor.Text, 0)));
  finally
    Imposto.Free;
  end;
end;

procedure TfrmPrincipal.DestruirObjetos;
begin
  if Assigned(OperacaoSoma) then
    FreeAndNil(OperacaoSoma);
  if Assigned(OperacaoSubtracao) then
    FreeAndNil(OperacaoSubtracao);
  if Assigned(OperacaoMultiplicacao) then
    FreeAndNil(OperacaoMultiplicacao);
  if Assigned(OperacaoDivisao) then
    FreeAndNil(OperacaoDivisao);
end;

procedure TfrmPrincipal.AplicarValorTecla(var Key: Char);
begin
  if Key = ',' then
    btnSinalDecimal.Click
  else
    preencherVisor(Key);
  Key := #0;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DestruirObjetos();
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  TCalculadora.operacaoAtiva := tpoNada;
end;

procedure TfrmPrincipal.LimparCamposImpostos;
begin
  edtImpostoA.Clear;
  edtImpostoB.Clear;
  edtImpostoC.Clear;
end;

procedure TfrmPrincipal.preencherVisor(cDigito: String);
begin
  if TCalculadora.zerar then
  begin
     edtVisor.Text := EmptyStr;
     TCalculadora.zerar := False;
     if cDigito = ',' then
       edtVisor.Text := '0';
  end;
  edtVisor.Text := edtVisor.Text + cDigito;
  edtVisor.SelStart := Length(edtVisor.Text);
  TCalculadora.nUltimoDigitado := StrToFloat(edtVisor.Text);
end;

end.
