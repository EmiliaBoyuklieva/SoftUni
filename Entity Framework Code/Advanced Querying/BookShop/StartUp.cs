namespace BookShop
{
    using BookShop.Models;
    using BookShop.Models.Enums;
    using Data;
    using Initializer;
    using Microsoft.EntityFrameworkCore;
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using System.Text;

    public class StartUp
    {
        public static void Main()
        {
            using var db = new BookShopContext();
            //DbInitializer.ResetDatabase(db);

            //01.
            // string command = Console.ReadLine();
            // string result = GetBooksByAgeRestriction(db, command);

            //02. 03. 11. 12. 13.
            // string result = GetMostRecentBooks(db);

            //04.
            //int year = int.Parse(Console.ReadLine());
            //string result = GetBooksNotReleasedIn(db, year);

            //06.
            //string date = Console.ReadLine();
            //string result = GetBooksReleasedBefore(db, date);

            //05. 07. 08. 09.
            string input = Console.ReadLine();
            string result = GetAuthorNamesEndingIn(db, input);

            //10.
            //int lenght = int.Parse(Console.ReadLine());
            //int result = CountBooks(db, lenght);

            //14.
            //IncreasePrices(db);

            //15.
            //int result = RemoveBooks(db);

            Console.WriteLine(result);


        }

        //1. Age Restriction
        public static string GetBooksByAgeRestriction(BookShopContext context, string command)
        {
            StringBuilder sb = new StringBuilder();

            var ageRestriction = Enum.Parse<AgeRestriction>(command, true);

            var books = context
                .Books
                .Where(b => b.AgeRestriction == ageRestriction)
                .OrderBy(b => b.Title)
                .Select(b => b.Title)
                .ToList();

            foreach (var item in books)
            {
                sb.AppendLine(item);
            }

            return sb.ToString().TrimEnd();
        }

        //2. Golden Books
        public static string GetGoldenBooks(BookShopContext context)
        {
            StringBuilder sb = new StringBuilder();

            var books = context
                .Books
                .Where(b => b.EditionType == EditionType.Gold
                         && b.Copies < 5000)
                .OrderBy(b => b.BookId)
                .Select(b => b.Title)
                .ToList();

            foreach (var item in books)
            {
                sb.AppendLine(item);
            }

            return sb.ToString().TrimEnd();
        }

        //3. Books by Price
        public static string GetBooksByPrice(BookShopContext context)
        {
            StringBuilder sb = new StringBuilder();

            var books = context
                .Books
                .Where(b => b.Price > 40)
                .OrderByDescending(b => b.Price)
                .Select(b => new { b.Title, b.Price })
                .ToArray();

            foreach (var item in books)
            {
                sb.AppendLine($"{item.Title} - ${item.Price:f2}");
            }

            return sb.ToString().TrimEnd();
        }

        //4. Not Released In
        public static string GetBooksNotReleasedIn(BookShopContext context, int year)
        {
            StringBuilder sb = new StringBuilder();

            var books = context
                .Books
                .Where(b => b.ReleaseDate.Value.Year != year)
                .OrderBy(b => b.BookId)
                .Select(b => b.Title)
                .ToList();

            foreach (var item in books)
            {
                sb.AppendLine(item);
            }

            return sb.ToString().TrimEnd();
        }

        //5. Book Titles by Category
        public static string GetBooksByCategory(BookShopContext context, string input)
        {
            List<string> books = new List<string>();

            var command = input.Split(" ", StringSplitOptions.RemoveEmptyEntries);

            for (int i = 0; i < command.Length; i++)
            {
                var booksCategory = context
                    .Books
                    .Include(bc => bc.BookCategories)
                    .Where(b => b.BookCategories.Any(c => c.Category.Name.ToLower() == command[i].ToLower()))
                    .OrderBy(b => b.Title)
                    .Select(b => b.Title)
                    .ToList();


                foreach (var item in booksCategory)
                {
                    books.Add(item);
                }
            }

            var ordered = books.OrderBy(x => x).ToList();

            return string.Join(Environment.NewLine, ordered);

        }

        //6. Released Before Date
        public static string GetBooksReleasedBefore(BookShopContext context, string date)
        {
            StringBuilder sb = new StringBuilder();


            var books = context
                .Books
                .Where(b => b.ReleaseDate.Value < DateTime.ParseExact(date, "dd-MM-yyyy", CultureInfo.InvariantCulture))
                .OrderByDescending(b => b.ReleaseDate)
                .Select(b => new { b.Title, b.EditionType, b.Price })
                .ToList();

            foreach (var item in books)
            {
                sb.AppendLine($"{item.Title} - {item.EditionType} - ${item.Price:f2}");
            }

            return sb.ToString().TrimEnd();
        }

        //7. Author Search
        public static string GetAuthorNamesEndingIn(BookShopContext context, string input)
        {
            StringBuilder sb = new StringBuilder();

            var authors = context
                .Authors
                .Where(a => a.FirstName.EndsWith(input))
                .ToList()
                .Select(a => new { fullName = $"{a.FirstName} {a.LastName}"})
                .OrderBy(a=>a.fullName)
                .ToArray();

            foreach (var author in authors)
            {
                sb.AppendLine($"{author.fullName}");
            }

            return sb.ToString().TrimEnd();
        }

        //8. Book Search
        public static string GetBookTitlesContaining(BookShopContext context, string input)
        {
            StringBuilder sb = new StringBuilder();

            var books = context
                .Books
                .Where(b => b.Title.ToLower().Contains(input.ToLower()))
                .OrderBy(b => b.Title)
                .Select(b => b.Title)
                .ToList();

            foreach (var item in books)
            {
                sb.AppendLine(item);
            }

            return sb.ToString().TrimEnd();
        }

        //9. Book Search by Author
        public static string GetBooksByAuthor(BookShopContext context, string input)
        {
            StringBuilder sb = new StringBuilder();

            var books = context
                .Books
                .Where(b => b.Author.LastName.ToLower().StartsWith(input.ToLower()))
                .OrderBy(b => b.BookId)
                .Select(b => new { b.Title, fullName = $"{b.Author.FirstName} {b.Author.LastName}" })
                .ToList();

            foreach (var item in books)
            {
                sb.AppendLine($"{item.Title} ({item.fullName})");
            }

            return sb.ToString().TrimEnd();
        }

        //10. Count Books
        public static int CountBooks(BookShopContext context, int lengthCheck)
        {
            StringBuilder sb = new StringBuilder();

            var books = context
                .Books
                .Where(b => b.Title.Length > lengthCheck)
                .ToList();

            return books.Count();
        }

        //11. Total Book Copies
        public static string CountCopiesByAuthor(BookShopContext context)
        {
            StringBuilder sb = new StringBuilder();

            var authors = context
                .Authors
                .Include(b => b.Books)
                .Select(b => new
                {
                    fullName = $"{b.FirstName} {b.LastName}",
                    total = b.Books.Sum(b => b.Copies)
                })
                .OrderByDescending(b => b.total)
                .ToList();

            foreach (var item in authors)
            {
                sb.AppendLine($"{item.fullName} - {item.total}");
            }

            return sb.ToString().TrimEnd();
        }

        //12. Profit by Category
        public static string GetTotalProfitByCategory(BookShopContext context)
        {
            StringBuilder sb = new StringBuilder();

            var profits = context
                .Categories
                .Select(b => new
                {
                    bookCategory = b.Name,
                    total = b.CategoryBooks.Sum(b => b.Book.Price * b.Book.Copies)
                })
                .OrderByDescending(b => b.total)
                .ThenBy(c => c.bookCategory)
                .ToList();

            foreach (var item in profits)
            {
                sb.AppendLine($"{item.bookCategory} ${item.total:f2}");
            }

            return sb.ToString().TrimEnd();
        }

        //13. Most Recent Books
        public static string GetMostRecentBooks(BookShopContext context)
        {
            StringBuilder sb = new StringBuilder();

            var recentBooks = context
                .Categories
                .Select(c => new
                {
                    categoryName = c.Name,
                    books = c.CategoryBooks
                           .OrderByDescending(b => b.Book.ReleaseDate)
                           .Select(b => new { b.Book.ReleaseDate, b.Book.Title })
                           .Take(3)

                })
                .OrderBy(c => c.categoryName)
                .ToList();

            foreach (var item in recentBooks)
            {
                sb.AppendLine($"--{item.categoryName}");

                foreach (var book in item.books)
                {
                    sb.AppendLine($"{book.Title} ({book.ReleaseDate.Value.Year})");
                }
            }

            return sb.ToString().TrimEnd();

        }

        //14. Increase Prices
        public static void IncreasePrices(BookShopContext context)
        {
            var books = context
                .Books
                .Where(b => b.ReleaseDate.Value.Year < 2010)
                .ToList();

            foreach (var item in books)
            {
                item.Price += 5;
            }

        }

        //15. Remove Books
        public static int RemoveBooks(BookShopContext context)
        {

            var books = context
               .Books
               .Where(b => b.Copies < 4200)
               .ToList();

            context.RemoveRange(books);
            context.SaveChanges();
            return books.Count();

        }
    }

}


