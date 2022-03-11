
capture program drop povertyrate
program povertyrate

	syntax varlist(max=1) [if] [in], Weight(name) [BY(name) Years(name)]
		
		if "`by'" != "" {
		
			if "`years'" != "" {
				quietly levelsof `years', local(year)
					foreach x in `year' {
						quietly statsmat `varlist' [aweight=`weight'] if `years'==`x', s(mean) by(`by') matrix(m_`x')	
					}
				quietly summarize `years'
				matrix def mat_final = m_`r(min)'
				local min = `r(min)' + 1
					forvalues i=`min'/`r(max)' {
						matrix def mat_final = mat_final, m_`i'
					}
				matrix colnames mat_final = `year'
				matrix list mat_final
			}
			
			else { // of the years
				statsmat `varlist' [aweight=`weight'], s(mean) by(`by') matrix(mat_final)
			}
		}	
		else { // of the by
			
			if "`years'" != "" {
				quietly levelsof `years', local(year)
					foreach x in `year' {
						quietly statsmat `varlist' [aweight=`weight'] if `years'==`x', s(mean) matrix(m_`x')	
					}
				quietly summarize `years'
				matrix def mat_final = m_`r(min)'
				local min = `r(min)' + 1
					forvalues i=`min'/`r(max)' {
						matrix def mat_final = mat_final, m_`i'
					}
				matrix colnames mat_final = `year'
				matrix list mat_final
			}
			else {
				statsmat `varlist' [aweight=`weight'], s(mean) matrix(mat_final)
			}
		}

end

