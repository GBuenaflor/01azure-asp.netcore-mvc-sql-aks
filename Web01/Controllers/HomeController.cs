using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Web01.Models;

namespace Web01.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            return View();
        }

        ///// <summary>
        ///// Get current user ip address.
        ///// </summary>
        ///// <returns>The IP Address</returns>
        //public static string GetUserIPAddress()
        //{
        //    var context = System.Web.HttpContext.Current;
        //    string ip = String.Empty;

        //    if (context.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] != null)
        //        ip = context.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
        //    else if (!String.IsNullOrWhiteSpace(context.Request.UserHostAddress))
        //        ip = context.Request.UserHostAddress;

        //    if (ip == "::1")
        //        ip = "127.0.0.1";

        //    return ip;
        //}

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
