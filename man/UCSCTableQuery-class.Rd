\name{UCSCTableQuery-class}
\docType{class}

\alias{UCSCTableQuery-class}

% Accessors:
\alias{browserSession,UCSCTableQuery-method}
\alias{browserSession<-}
\alias{browserSession<-,UCSCTableQuery,UCSCSession-method}
\alias{trackName}
\alias{trackName,UCSCTableQuery-method}
\alias{trackName<-}
\alias{trackName<-,UCSCTableQuery-method}
\alias{tableName}
\alias{tableName,UCSCTableQuery-method}
\alias{tableName<-}
\alias{tableName<-,UCSCTableQuery-method}
\alias{range,UCSCTableQuery-method}
\alias{range<-,UCSCTableQuery,RangesList-method}

% Query execution
\alias{tableNames}
\alias{tableNames,UCSCTableQuery-method}
\alias{getTable}
\alias{getTable,UCSCTableQuery-method}
\alias{track}
\alias{track,UCSCTableQuery-method}

% Constructor:
\alias{ucscTableQuery}
\alias{ucscTableQuery,UCSCSession-method}

% Show:
\alias{show,UCSCTableQuery-method}

\title{Querying UCSC Tables}
\description{The UCSC genome browser is backed by a large database,
  which is exposed by the Table Browser web interface. Tracks are
  stored as tables, so this is also the mechanism for retrieving tracks. The
  \code{UCSCTableQuery} class represents a query against the Table
  Browser. Storing the query fields in a formal class facilitates
  incremental construction and adjustment of a query.} 

\details{
  There are four supported fields for a table query:
  \describe{
    \item{session}{The \code{\linkS4class{UCSCSession}} instance from
      the tables are retrieved. Although all sessions are based on the
      same database, the set of user-uploaded tracks, which are represented
      as tables, is not the same, in general.
    }
    \item{trackName}{The name of a track from which to retrieve a
      table. Each track can have multiple tables. Many times there is a
      primary table that is used to display the track, while the other
      tables are supplemental. Sometimes, tracks are displayed by aggregating
      multiple tables.
    }
    \item{tableName}{The name of the specific table to retrieve. May be
      \code{NULL}, in which case the behavior depends on how the query
      is executed, see below.
    }
    \item{range}{A \code{\link[BSgenome:RangesList-methods]{RangesList}}
      indicating the portion of the table to retrieve, in genome
      coordinates. The \code{genome} indicated by the \code{RangesList}
      also determines which tracks are available and must always be
      non-\code{NULL}.  If the \code{RangesList} is empty, the table is
      downloaded for the entire genome.
    }
  } 

  A common workflow for querying the UCSC database is to create an
  instance of \code{UCSCTableQuery} using the \code{ucscTableQuery}
  constructor, invoke \code{tableNames} to list the available tables for
  a track, and finally to retrieve the desired table either as a
  \code{data.frame} via \code{getTable} or as a \code{RangedData} track
  via \code{track}. See the examples.

  The reason for a formal query class is to facilitate multiple queries
  when the differences between the queries are small. For example, one
  might want to query multiple tables within the track and/or same
  genomic region, or query the same table for multiple regions. The
  \code{UCSCTableQuery} instance can be incrementally adjusted for each
  new query. Some caching is also performed, which enhances performance. 
}

\section{Constructor}{
  \describe{
    \item{}{
      \code{ucscTableQuery(x, track, range = GenomicRanges(), table = NULL)}: 
      Creates a \code{UCSCTableQuery} with the
      \code{UCSCSession} given as \code{x} and the track name given by
      the single string \code{track}. \code{range} should be a
      \code{RangesList} instance, and it effectively defaults to
      \code{range(x)}. Any missing information in \code{range}, often
      the genome identifier, is filled in from \code{range(x)}. The
      table name is given by \code{table}, which may be a single string
      or \code{NULL}.
    }
  }
}

\section{Executing Queries}{
  Below, \code{object} is a \code{UCSCTableQuery} instance.
  
  \describe{
    \item{}{
      \code{track(object)}:
      Retrieves the indicated table as a track, i.e. a \code{RangedData}
      instance. Note that not all tables are available as tracks.
    }
    \item{}{
      \code{getTable(object)}: Retrieves the indicated table as a
      \code{data.frame}. Note that not all tables are output in
      parseable form.
    }
    \item{}{
      \code{tableNames(object)}: Gets the names of the tables available
      for the session, track and range specified by the query.
    }
  }
}

\section{Accessor methods}{
  In the code snippets below, \code{x}/\code{object} is a
  \code{UCSCTableQuery} object.

  \describe{
    \item{}{\code{browserSession(object)},
      \code{browserSession(object) <- value}:
      Get or set the \code{UCSCSession} to query.
    }
    \item{}{\code{trackName(x)}, \code{trackName(x) <- value}: Get or
      set the single string indicating the track containing the table of
      interest.
    }
    \item{}{\code{tableName(x)}, \code{tableName(x) <- value}: Get or
      set the single string indicating the name of the table to
      retrieve. May be \code{NULL}, in which case the table is
      automatically determined.
    }
    \item{}{\code{range(x)}, \code{range(x) <- value}: Get or set the
      \code{RangesList} indicating the portion of the table to retrieve in
      genomic coordinates. Any missing information, such as the genome
      identifier, is filled in using \code{range(browserSession(x))}.
    }
  }
}

\author{ Michael Lawrence }

\examples{
\dontrun{
session <- browserSession()
genome(session) <- "mm9"
trackNames(session) ## list the track names
## choose the Conservation track for a portion of mm9 chr1
query <- ucscTableQuery(session, "Conservation",
                        GenomicRanges(57795963, 57815592, "chr12"))
## list the table names
tableNames(query)
## get the phastCons30way track
tableName(query) <- "phastCons30way"
## retrieve the track data
track(query)
## get a data.frame summarizing the multiple alignment
tableName(query) <- "multiz30waySummary"
getTable(query)
}
}

\keyword{methods}
\keyword{classes}