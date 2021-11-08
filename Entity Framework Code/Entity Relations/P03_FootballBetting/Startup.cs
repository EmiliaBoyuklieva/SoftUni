using P03_FootballBetting.Data;
using System;

namespace P03_FootballBetting
{
    public class Startup
    {
        static void Main(string[] args)
        {

            FootballBettingContext db = new FootballBettingContext();
            db.Database.EnsureCreated();
            // db.Database.EnsureDeleted();
        }
    }
}
