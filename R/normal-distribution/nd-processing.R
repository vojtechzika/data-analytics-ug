# ============================================================
# 1. LOAD AND INSPECT THE DATA
# ============================================================

# Load data from csv file into a data.frame called df
df <- read.csv("data/raw/height-weight-by-sex.csv")

# Print df to the console
df

# Open df in "Excel-style" spreadsheet view
# (leave this tab open — it reflects every change we make below)
View(df)

# Print just the column names (handy for copy-pasting into code)
colnames(df)

# Summary statistics for every column
summary(df)

# Histogram for every numeric column at once
# (hist() normally only works on a single vector, but the Hmisc
# package adds a method that lets it work on a whole data.frame)
library(Hmisc)
hist(df)

# ============================================================
# 2. PROBLEM I.: Height and Weight are in inches and pounds
#    (not metric) — convert to cm and kg
# ============================================================

# Conversion factors.
# Named in two different styles on purpose, to compare conventions:
multi_in_to_cm <- 2.54    # snake_case (R's default/recommended style)
multiLbToKg <- 0.453592   # camelCase (shown here only for comparison —
# pick one style and stay consistent in real code)

# Step 1: convert units, store results as vectors first
height_in_cm_vector <- df$Height * multi_in_to_cm
weight_in_kg_vector <- df$Weight * multiLbToKg

height_in_cm_vector
weight_in_kg_vector

# Step 2: round to sensible precision
# (height: whole numbers, weight: one decimal place)
height_in_cm_vector <- round(height_in_cm_vector, 0)
weight_in_kg_vector <- round(weight_in_kg_vector, 1)

height_in_cm_vector
weight_in_kg_vector

# Step 3: create two new (empty) columns in df
df$height_cm <- NA
df$weight_kg <- NA

# Step 4: fill those columns with the converted vectors
df$height_cm <- height_in_cm_vector
df$weight_kg <- weight_in_kg_vector

# --------------------------------------------------------------
# Steps 1-4 above are written out explicitly for clarity.
# In practice, you can do the same conversion in a single line:
# --------------------------------------------------------------
df$height_cm <- round(df$Height * multi_in_to_cm, 0)
df$weight_kg <- round(df$Weight * multiLbToKg, 1)


# ============================================================
# 3. CLEAN UP: rename original imperial columns to make
#    units explicit
#    Column is called "Gender", but it actually
#    records sex (male/female) — rename it accordingly
# ============================================================
names(df)[names(df) == "Height"] <- "height_in"
names(df)[names(df) == "Weight"] <- "weight_lb"

names(df)[names(df) == "Gender"] <- "sex"

# Confirm the renaming worked
colnames(df)
summary(df)


# ============================================================
# 4. SANITY CHECK: confirm the unit conversion didn't distort
#    the data — it should just rescale each value, not change
#    its relative position (i.e., the tallest person in inches
#    is still the tallest person in cm)
# ============================================================

# Graphically: shapes of the imperial and metric histograms
# should look identical, just with different x-axis numbers
# (e.g. a bell curve centered ~66 for height_in should look
# exactly like a bell curve centered ~168 for height_cm)
hist(df)

# Numerically: correlation measures how strongly two variables
# move together. Since height_cm = height_in * 2.54 (a fixed
# multiplier), every point would fall on a perfectly straight
# line if there were no rounding — so correlation should be 1,
# or very close to it, since we rounded height_cm and weight_kg
# earlier (rounding introduces tiny deviations from the exact
# straight line).
# If it's noticeably less than ~0.999, something went wrong in
# the conversion (e.g. rows got reordered, or the wrong columns
# were compared).
cor(df$height_in, df$height_cm)
cor(df$weight_lb, df$weight_kg)


# ============================================================
# 6. SAVE THE CLEANED DATA
# ============================================================
write.csv(df, "data/clean/height-weight-by-sex.csv", row.names = FALSE)

