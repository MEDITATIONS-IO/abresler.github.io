library(rvest)
css = "#div_coaches"
url = "http://www.basketball-reference.com/coaches/"

url %>>% html() %>>%
	{html_table(x = .,trim = T,header = F)} %>>%
	data.frame() %>>%
	(coaches = tbl_df(.[3:nrow(.),]))

names(coaches) <- c('coach','from','to','birthday','university')
row.names(coaches) = NULL
coaches %>%
	filter(!is.na(from)) %>%
	filter(!coach == 'Coach') -> coaches

coaches$coach %>>% {grepl(pattern = '\\*',x = .)} -> coaches$hall_of_fame
coaches$coach %>>% {gsub(pattern = '\\*',replacement = '',x = .)} %>>% Trim() -> coaches$coach

url %>>% html() %>>%
	html_nodes(css = 'strong a') %>>%
	html_text() %>>%(
		active = .
	)

coaches$coach %in% active -> coaches$active_coach
url %>>% html() %>>%
	html_nodes(css ='td:nth-child(1) a') %>>%
	html_attrs() %>>% {paste0('http://www.basketball-reference.com',.)} -> coaches$coach_url

coaches$birthday %>>% as.Date('%B %d , %Y') -> coaches$birthday

coaches %>%
	filter(is.na(birthday)) %>%
	select(coach,birthday) -> missing_coaches

"https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=david%20blatt%20date%20of%20birth" %>>%
	html() %>>%
	html_node(xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "_eF", " " ))]')

coaches$birthday %>>% year() -> coaches$birth_year
