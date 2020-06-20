<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StartPage.aspx.cs" Inherits="PrograBases.WebPages.Normal_user.StartPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div id="propiedadesUsuario">

            <asp:GridView runat="server" CssClass="gridNormalUser" id="GridPropiedades" AutoGenerateColumns="false" Visible="false" ShowFooter="True" CellPadding="3" DataKeyNames="numFinca" >
                <Columns>
                    <asp:TemplateField HeaderText="Numero de Finca" > 
                        <FooterTemplate>
                            <asp:TextBox ID="txtNewNumeroFinca" runat="server" ></asp:TextBox>
                        </FooterTemplate> 
                        <ItemTemplate> 
                            <asp:Label ID="labelNumeroFinca" runat="server" Text='<%# Bind("numFinca") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Valor"> 
                        <FooterTemplate>
                            <asp:TextBox ID="txtNewValor" runat="server" ></asp:TextBox>
                        </FooterTemplate> 
                        <ItemTemplate> 
                            <asp:Label ID="labelValor" runat="server" Text='<%# "$" + Eval("valor") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Direccion"> 
                        <FooterTemplate>
                            <asp:TextBox ID="txtNewDireccion" runat="server" ></asp:TextBox>
                        </FooterTemplate> 
                        <ItemTemplate> 
                            <asp:Label ID="labelDireccion" runat="server" Text='<%# Bind("direccion") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Propietarios" ShowHeader="False">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkvVerConceptosDeCobro" runat="server" CausesValidation="True" Text="Conceptos de cobro"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:CommandField HeaderText="Borrar" ShowDeleteButton="True" ShowHeader="True" />
                
                </Columns>
                <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />

            </asp:GridView>
        </div>
    </form>
</body>
</html>
