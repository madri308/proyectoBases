<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Normal_user/NormalUser_Site.Master" AutoEventWireup="true" CodeBehind="tablaComprobantesDePago.aspx.cs" Inherits="PrograBases.WebPages.Normal_user.tablaComprobantesDePago" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="divComprobantesDePago" style="margin-left:11%">
        <asp:GridView runat="server" CssClass="gridNormalUser" id="GridComprobantesDePago" AutoGenerateColumns="false" Visible="false" ShowFooter="false" CellPadding="3" DataKeyNames="id">
            <Columns>
                <asp:BoundField HeaderText="" DataField="id" InsertVisible="False" ReadOnly="True" SortExpression="id" Visible="false"/>

                <asp:BoundField HeaderText="Fecha" DataField="fecha" InsertVisible="False" ReadOnly="True" SortExpression="fecha"/>

                <asp:BoundField HeaderText="Total" DataField="total" InsertVisible="False" ReadOnly="True" SortExpression="total" />

                <asp:TemplateField HeaderText="" ShowHeader="False">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkvVerRecibosDeComprobante" runat="server" CausesValidation="True" Text="Recibos pagados" OnClick="lnkvVerRecibosDeComprobante_Click"></asp:LinkButton>
                        </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center"/>
        </asp:GridView>
    </div>

</asp:Content>
