install.packages("RMySQL")
library(RMySQL)

        ucscDb <- dbConnect(MySQL(), user="genome",
                            host="genome-mysql.cse.ucsc.edu")
        result <- dbGetQuery(ucscDb, "show databases"); dbDisconnect(ucscDb)

# Always disconnect

        result

        hg19 <- dbConnect(MySQL(), user="genome", db="hg19",
                            host="genome-mysql.cse.ucsc.edu")

        allTables <- dbListTables(hg19)
        length(allTables)

# Show all Table
        allTables[1:5]
# Fileds on this Table affyU133Plus2
        dbListFields(hg19,"affyU133Plus2")
        dbGetQuery(hg19, "select count(*) from affyU133Plus2")

# Read from Table
        affyData <- dbReadTable(hg19, "affyU133Plus2")
        head(affyData)
#Select a specific subset
        query <- dbSendQuery(hg19, "select * from affyU133Plus2 where mismatches between 1 and 3")
        affyMis <- fetch(query); quantile(affyMis$misMatches)
        affyMisSmall <- fetch(query, n=10) ; dbClearResult(query)
        dim(affyMisSmall)

        dbDisconnect(hg19)

#        http://cran.r-project.org/web/packages/RMySQL/RMySQL.pdf
#
#------------------ HDF5--------------------
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
library(rhdf5)
created = h5createFile("example.h5")
created
# Create Group
        created = h5createGroup("example.h5","foo")
        created = h5createGroup("example.h5","baa")
        created = h5createGroup("example.h5","foo/foobaa")
        h5ls("example.h5")
#Write to Group
        A = matrix(1:10, nrow = 5, ncol = 2)
  # write
        h5write(A, "example.h5", "foo/A")
        B = array(seq(0.1,2.0, by=0.1), dim = c(5,2,2))
        attr(B,"scale") <- "liter"
        h5write(B,"example.h5","foo/foobaa/B")
        h5ls("example.h5")

#Write a data set
        df = data.frame(1L:5L, seq(0,1, length.out = 5),
                c("ab","cde","fghi","a","s"), stringAsFactor = FALSE)
        h5write(df, "example.h5", "df")
        h5ls("example.h5")
# Reading Data
        readA = h5read("example.h5","foo/A")
        readB = h5read("example.h5","foo/foobaa/B")
        readdf = h5read("example.h5","df")

# Writing and Reading chunks
        h5write(c(12,13,14), "example.h5","foo/A", index= list(1:3,1))
        h5read("example.h5","foo/A")
###-------------Reading from the web---------
#  http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en
# Getting data off webpages - readLines()
        con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
        htmlCode = readLines(con)
        close(con)
        htmlCode

# Parsing XML
        library(XML)
        url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
        html <- htmlTreeParse(url, useInternalNodes = TRUE)

        xpathSApply(html, "//title", xmlValue)
# the html tag was change to this...
        xpathSApply(html, "//td[@class='gsc_a_c']", xmlValue)

# GET from httr package
        library(httr)
        html2 = GET(url)
        content2 = content(html2, as = "text")
# I think parsed help to arange it
        parsedHtml = htmlParse(content2,asText = TRUE)

        xpathSApply(parsedHtml, "//title", xmlValue)

# Accessing website with Password
pg2 = GET("http://httpbin.org/basic-auth/user/passwd",
          authenticate("user","passwd"))
pg2

#------Use handle
        google = handle("http://google.com")
        pg1 = GET(handle=google, path="/")
        pg2 = GET(handle=google, path="search")

# Reading from API
        myapp = oauth_app("twitter",
                          key = "",
                          secret = ""  )
        sig = sign_oauth1.0(myapp,
                            token = "",
                            token_secret = "" )
        homeTL = GET("", sig)
