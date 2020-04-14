using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace Web01.Models
{
    public class WebDataContext : DbContext
    {
        public WebDataContext (DbContextOptions<WebDataContext> options)
            : base(options)
        {
            Database.EnsureCreated();
        }

        public DbSet<Web01.Models.WebData> WebData { get; set; }
 

    }
}
