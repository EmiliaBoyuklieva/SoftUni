﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace P03_FootballBetting.Data.Models
{
    public class Position
    {
        public Position()
        {
            this.Players = new HashSet<Player>();
        }
        [Key]
        public int PositionId { get; set; }

        [MaxLength(20)]
        [Required]
        public string Name { get; set; }

        public virtual ICollection<Player> Players { get; set; }
    }
}
