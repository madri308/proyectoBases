﻿<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Admin/Admin_Site.Master" AutoEventWireup="true" CodeBehind="tablaCambios.aspx.cs" Inherits="PrograBases.WebPages.Admin.tablaCambios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="tablaCambios" style="margin-left:11%; padding-top:1%">

        <asp:GridView runat="server" ID="GridFechas" AutoGenerateColumns="true" Visible="false" ShowFooter="false" CellPadding="3">
            
            <columns>
                <asp:TemplateField HeaderText="" ShowHeader="False">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkbVerCambiosDeFecha" runat="server" CausesValidation="True" OnClick="lnkbVerCambiosDeFecha_Click" Text="Ver cambios"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </columns>

            <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />
        </asp:GridView>
        <div runat="server" visible="false" id="DivJsonAntes">
            <p> Json Antes </p>
            <asp:GridView runat="server" ID="GridJsonAntes" AutoGenerateColumns="true" Visible="false" ShowFooter="false" CellPadding="3">
                <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />
            </asp:GridView>
        </div>
        <div runat="server" visible="false" id="DivJsonDespues">
            <p> Json Despues </p>
            <asp:GridView runat="server" ID="GridJsonDespues" AutoGenerateColumns="true" Visible="false" ShowFooter="false" CellPadding="3">
                <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />
            </asp:GridView>
        </div>
    </div>
</asp:Content>
