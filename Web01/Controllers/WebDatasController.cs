using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Web01.Models;

namespace Web01.Controllers
{
    public class WebDatasController : Controller
    {
        private readonly WebDataContext _context;

        public WebDatasController(WebDataContext context)
        {
            _context = context;
        }

        // GET: WebDatas
        public async Task<IActionResult> Index()
        {
            return View(await _context.WebData.ToListAsync());
        }

        // GET: WebDatas/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var webData = await _context.WebData
                .FirstOrDefaultAsync(m => m.Id == id);
            if (webData == null)
            {
                return NotFound();
            }

            return View(webData);
        }

        // GET: WebDatas/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: WebDatas/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,Name")] WebData webData)
        {
            if (ModelState.IsValid)
            {
                _context.Add(webData);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(webData);
        }

        // GET: WebDatas/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var webData = await _context.WebData.FindAsync(id);
            if (webData == null)
            {
                return NotFound();
            }
            return View(webData);
        }

        // POST: WebDatas/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,Name")] WebData webData)
        {
            if (id != webData.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(webData);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!WebDataExists(webData.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(webData);
        }

        // GET: WebDatas/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var webData = await _context.WebData
                .FirstOrDefaultAsync(m => m.Id == id);
            if (webData == null)
            {
                return NotFound();
            }

            return View(webData);
        }

        // POST: WebDatas/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var webData = await _context.WebData.FindAsync(id);
            _context.WebData.Remove(webData);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool WebDataExists(int id)
        {
            return _context.WebData.Any(e => e.Id == id);
        }
    }
}
