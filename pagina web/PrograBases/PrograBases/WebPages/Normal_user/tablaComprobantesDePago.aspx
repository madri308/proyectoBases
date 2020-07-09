<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Normal_user/NormalUser_Site.Master" AutoEventWireup="true" CodeBehind="tablaComprobantesDePago.aspx.cs" Inherits="PrograBases.WebPages.Normal_user.tablaComprobantesDePago" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="divComprobantesDePago" style="margin-left:11%">
        <asp:GridView runat="server" CssClass="gridNormalUser" id="GridComprobantesDePago" AutoGenerateColumns="true" Visible="false" ShowFooter="false" CellPadding="3">
        
            <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center"/>
        </asp:GridView>
    </div>

</asp:Content>
