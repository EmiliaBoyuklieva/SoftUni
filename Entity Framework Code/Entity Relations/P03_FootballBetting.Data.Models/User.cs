using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace P03_FootballBetting.Data.Models
{
    public class User
    {
        public User()
        {
            this.Bets = new HashSet<Bet>();
        }
        
        [Key]
        public int UserId { get; set; }
        [MaxLength(50)]
        [Required]
        public string Username { get; set; }
        [MaxLength(30)]
        [Required]
        public string Password { get; set; }
        [MaxLength(80)]
        [Required]
        public string Email { get; set; }
        [MaxLength(50)]
        [Required]
        public string Name { get; set; }
        [Required]
        public decimal Balance { get; set; }

        public virtual ICollection<Bet> Bets { get; set; }
    }
}
