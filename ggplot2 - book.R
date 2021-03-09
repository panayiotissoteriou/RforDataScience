ggplot2::mpg
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg)
?mpg
ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = cyl))
ggplot(data = mpg) +
  geom_point(mapping = aes(x = class, y = drv))
ggplot(data = mpg) +
  geom_point(mapping = aes(x = cyl, y = hwy, colour = displ < 5))
?geom_point
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl)) +
  facet_grid(drv ~ cyl)
  
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
facet_grid(drv ~ .)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)
?facet_wrap
?facet_grid

p <- ggplot(mtcars, aes(wt, disp)) + geom_point()
p + facet_wrap(vars(vs, am))
?mtcars

# Geometric objects
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, color = drv), show.legend = FALSE)

#2 ways to write the same code
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

# same code as ^ but less busy:
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

#modifying this ^, but only one of the 2 geom functions
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color=class)) +
  geom_smooth()

# alternatively, only selecting one part to show the smooth line
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color=class)) +
  geom_smooth(data = filter(mpg, class == "midsize"), 
              se = FALSE)

#exercises
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
    geom_point(show.legend = TRUE) +
    geom_smooth(se = FALSE)



# Recreate exercise: graph 1
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(se = FALSE)
# Recreate exercise: graph 2
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, group = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)

# Recreate exercise: graph 3
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)

# Recreate exercise: graph 4
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(colour = drv)) +
  geom_smooth(se = FALSE)

# Recreate exercise: graph 5
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, linetype = drv)) +
  geom_point (mapping = aes(colour = drv))+
  geom_smooth(se = FALSE)

# Recreate exercise: graph 6
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point ()

# Statistical transformations
?stat_bin
?geom_bar()
?stat_summary
?geom_pointrange

#exercises: p26: 1 - DID NOT SOLVE
ggplot(data = diamonds) +
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median)

ggplot(data = diamonds) +
  geom_pointrange(
    mapping = aes(x = cut, y = depth),
  ymin = min,
  ymax = max)

#exercise 2: geom_col vs geom_bar
ggplot(data = diamonds, mapping = aes(x = cut, y = depth)) +
  geom_col()
  
ggplot(data = diamonds, mapping = aes(x = cut)) +
  geom_bar()

#exercise 3: geom and stat pairs
stat_summary is paired w/ histogram, freqpoly, pointrange 
geoms are paired with stat: bin, count
  --> geom_bar is paired w/ stat_count
  --> geom_col uses stat_identity

#exercise 4: stat_smooth
?stat_smooth()
  # stat_smooth = geom_smooth
    # Stat_smooth used with a non-standard geom
ggplot(data = diamonds, mapping = aes(x = cut, y = depth)) +
  stat_smooth()
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_smooth()

# exercise 5: using group = 1
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop.., group =1)) 

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop.., group = 1)) 
??..prop..
# position adjustments
#position = "identity"
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(alpha = 1/5, position = "identity")

ggplot(data = diamonds, mapping = aes(x = cut, color = clarity)) +
  geom_bar(fill = NA, position = "identity")

ggplot(data = diamonds, mapping = aes(x = cut, color = clarity)) +
  geom_bar(fill = NA, position = "identity")

#position = "position = fill"
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), 
           position = "fill")

#position = "dodge"
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), 
           position = "dodge")

#for scatter plots: position = "jitter" prevents overplotting by adding random noise
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), 
             position = "jitter")

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

 # can also use geom_jitter for the same result
ggplot(data = mpg) +
  geom_jitter(mapping = aes(x = displ, y = hwy))

?position_dodge
?position_fill
?position_identity
?position_jitter
?position_stack

# exercises p.31
# 1: what is wrong with this plot
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point()

?mpg

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter()

# 2: parameters controlling geom_jitter jittering
?geom_jitter
  #width and height parameters control jittering
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(width = 1, height = 10)

#3: compare and contrast geom_jitter and geom_count
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_count()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point()

# 4: default position adjustment for geom_boxplot
?geom_boxplot
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_boxplot(position = "dodge2")

#coordinate systems exercises: 1 - dunno how to have clarity in sepeeate pie charts
?diamonds
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), 
           position = "fill") +
  coord_polar() 

# exercise 2: 
?labs()

# exercise 3
library(mapproj)
nz <- map_data("nz")        
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = 'white', color = "black")

?coord_quickmap

?coord_map
if (require("maps"))
  nz <- map_data("nz")
  # Prepare a map of NZ
  nzmap <- ggplot(nz, aes(x = long, y = lat, group = group)) +
    geom_polygon(fill = "white", colour = "black")

#exercise 4
ggplot(data = mpg, mapping = aes(x = cty, y = hwy))+
  geom_point() +
  coord_fixed() 
  geom_abline() 

?coord_fixed
?geom_abline  
  
# Layered Grammar of Graphics
  # code for graphics template
  ggplot(data = <DATA>) +
    <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>),
                    stat = <STAT>), 
                    position = <POSITION>) +
  <COORDINATE_FUNCTION> +
  <FACET_FUNCTION>

  
  
