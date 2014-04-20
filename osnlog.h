/*
 * osnlog.h
 *
 *  Copyright (C) 2006-2013 Enterprise Information Management.Inc
 *  All rights reserved.
 *
 *  Created on: Dec 20, 2011
 *      Author: feiwen.tong@infocore.cn
 *      http://www.infocore.cn
 */

#ifndef OSNLOG_H_
#define OSNLOG_H_

#define DEBUG_DAEMON	0		/* daemon */
#define DEBUG_CONN		1		/* TCP/IP connection */
#define DEBUG_MSG		2		/* OSN COMMAND,XML Message */
#define DEBUG_DEV		3		/* local SAN Device */
#define DEBUG_APP		4		/* Application level ,oracle,domino,etc. */
#define DEBUG_SCSI		5		/* SCSI COMMADN level */

void osn_log_init(const char *proname);
void osn_set_loglevel(int level);
void osn_set_logdaemon(int daemon);
int  osn_get_loglevel();
int  osn_get_logdaemon();

void __log_info(const char *func, int line, const char *fmt, ...)
        __attribute__ ((format (printf, 3, 4)));
void __log_warning(const char *func, int line, const char *fmt, ...)
        __attribute__ ((format (printf, 3, 4)));
void __log_error(const char *func, int line, const char *fmt, ...)
        __attribute__ ((format (printf, 3, 4)));
void __log_debug(const char *func, int line, int level, const char *fmt, ...)
        __attribute__ ((format (printf, 4, 5)));

#define log_info(args...)       __log_info(__func__, __LINE__, ## args)
#define log_warning(args...)    __log_warning(__func__, __LINE__, ## args)
#define log_error(args...)      __log_error(__func__, __LINE__, ## args)
#define log_debug(args...)      __log_debug(__func__, __LINE__, ## args)

#endif /* OSNLOG_H_ */
