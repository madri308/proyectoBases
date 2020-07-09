<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Normal_user/NormalUser_Site.Master" AutoEventWireup="true" CodeBehind="tablaRecibos.aspx.cs" Inherits="PrograBases.WebPages.Normal_user.tablaRecibos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="divRecibos" style="margin-left:11%">
        <asp:GridView runat="server" CssClass="gridNormalUser" id="GridRecibos" AutoGenerateColumns="false" Visible="false" ShowFooter="false" CellPadding="3" DataKeyNames = "id">
            <Columns>
                <asp:BoundField HeaderText="Id" DataField="id" InsertVisible="False" ReadOnly="True" SortExpression="id" Visible="false"/>
                <asp:BoundField HeaderText="Id Concepto de cobro" DataField="id_CC" InsertVisible="False" ReadOnly="True" SortExpression="id_CC" />
                <asp:BoundField HeaderText="Monto" DataField="monto" InsertVisible="False" ReadOnly="True" SortExpression="monto" />
                <asp:BoundField HeaderText="Estado" DataField="estado" InsertVisible="False" ReadOnly="True" SortExpression="estado" />
                <asp:BoundField HeaderText="Fecha" DataField="fecha" InsertVisible="False" ReadOnly="True" SortExpression="fecha" />
                <asp:BoundField HeaderText="Fecha Vencimiento" DataField="fechaVence" InsertVisible="False" ReadOnly="True" SortExpression="fechaVence" />
                <asp:TemplateField HeaderText="" ShowHeader="False">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkvVerComprobantesDePago" runat="server" CausesValidation="True" Text="Comprobantes de pago" OnClick="lnkvVerComprobantesDePago_Click"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center"/>
        </asp:GridView>
    </div>
</asp:Content>
