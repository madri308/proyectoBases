using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PrograBases
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void logout_button_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/WebPages/loginPage.aspx");
        }
    }
}