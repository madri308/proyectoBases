<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Normal_user/NormalUser_Site.Master" AutoEventWireup="true" CodeBehind="StartPage.aspx.cs" Inherits="PrograBases.WebPages.Normal_user.StartPage1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="/css/Normal_user/StartPage.css" type="text/css" media="screen" />

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="propiedadesUsuario">
        <asp:GridView runat="server" CssClass="gridNormalUser" id="GridPropiedades" AutoGenerateColumns="false" Visible="false" ShowFooter="false" CellPadding="3" DataKeyNames="numFinca" >
            <Columns>
                <asp:BoundField HeaderText="Numero de Finca" DataField="numFinca" InsertVisible="False" ReadOnly="True" SortExpression="numFinca" />

                <asp:BoundField HeaderText="Valor" DataField="valor"  InsertVisible="False" ReadOnly="True" SortExpression="valor" />

                <asp:BoundField HeaderText="Direccion" DataField="direccion" InsertVisible="False" ReadOnly="True" SortExpression="direccion" />

                <asp:TemplateField HeaderText="" ShowHeader="False">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkvVerConceptosDeCobro" runat="server" CausesValidation="True" Text="Conceptos de cobro" OnClick="lnkvVerConceptosDeCobro_Click"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="" ShowHeader="False">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkvVerRecibosPagados" runat="server" CausesValidation="True" Text="Recibos pagados" OnClick="lnkvVerRecibosPagados_Click"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="" ShowHeader="False">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkvVerRecibosPendientes" runat="server" CausesValidation="True" Text="Recibos pendientes" OnClick="lnkvVerRecibosPendientes_Click"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
            <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />

        </asp:GridView>
    </div>
</asp:Content>
