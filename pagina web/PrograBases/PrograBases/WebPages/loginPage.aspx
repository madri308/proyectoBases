<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="loginPage.aspx.cs" Inherits="PrograBases.Pages.loginPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" href="/css/login.css" type="text/css" media="screen" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div id="loginFormContainer">
            <asp:Label runat="server" CssClass="loginLabel" ID="UsernameLabel" Text="Usuario:" AssociatedControlID="usernameTextBox" >
                <asp:textbox id="usernameTextBox" runat="server" CssClass="textBox" />
            </asp:Label>

            <asp:Label runat="server" CssClass="loginLabel" ID="PasswordLabel" Text="Contraseña:" AssociatedControlID="passwordTextBox" >
                <asp:textbox id="passwordTextBox" runat="server" CssClass="textBox" TextMode="Password"/>
            </asp:Label>
 
            <asp:Button runat="server" CssClass="loginButton" id="loginButton" Text="Login" OnClick="loginButton_Click" />
        
            <div id="respuestaDiv">
                <asp:Label runat="server" CssClass="RespuestaLabel" ID="RespuestaLabel" Visible="false" />
            </div>
        </div>

        <div runat="server" id="loading" style="text-align: center" hidden>
            <asp:Image ID="loadingImage" runat="server"  ImageUrl="~/91.gif" />
        </div>
    </form>
</body>
</html>
