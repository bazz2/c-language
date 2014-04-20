/*
 * osnlog.c
 *
 *  Copyright (C) 2006-2013 Enterprise Information Management.Inc
 *  All rights reserved.
 *
 *  Created on: Dec 20, 2011
 *      Author: feiwen.tong@infocore.cn
 *      http://www.infocore.cn
 */

#include <ctype.h>
#include <stdarg.h>
#include <stdio.h>
#include <syslog.h>
#include <sys/time.h>
#include <string.h>
#include <osn/osnpub/osnlog.h>

unsigned int log_daemon = 1;
unsigned int log_level = 0;

void osn_log_init(const char *proname)
{
	openlog(proname, 0, LOG_USER);
}

void osn_set_loglevel(int level)
{
	log_level = level;
}

void osn_set_logdaemon(int daemon)
{
	log_daemon = daemon;
}

int osn_get_loglevel()
{
	return log_level;
}

int osn_get_logdaemon()
{
	return log_daemon;
}

#if defined(aix) || defined(hpux)
static void
osn_vsyslog(int prio, const char *fmt, va_list ap)
{
	char buf[1024];
	vsnprintf(buf, 1024, fmt, ap);
	syslog(prio, buf);
}
#endif

static void dolog_nofunc(int prio, const char *fmt, va_list ap)
{
	if (log_daemon) {
		int len = strlen(fmt);
		char f[len+1+1];
		if (fmt[len] != '\n')
			sprintf(f, "%s\n", fmt);
		else
			sprintf(f, "%s", fmt);
#if defined(aix) || defined(hpux)
		osn_vsyslog(prio, f, ap);
#else
		vsyslog(prio, f, ap);
#endif
	} else {
		struct timeval time;

		gettimeofday(&time, NULL);
		fprintf(stderr, "%ld.%06ld: ", time.tv_sec, time.tv_usec);
		vfprintf(stderr, fmt, ap);
		fprintf(stderr, "\n");
		fflush(stderr);
	}
}

static void dolog(int prio, const char *func, int line, const char *fmt, va_list ap)
{
	if (log_level == 0) {
		dolog_nofunc(prio, fmt, ap);
		return;
	}

	if (log_daemon) {
		int len = strlen(func) + strlen(fmt);
		char f[len+1+1];
		if (fmt[len] != '\n')
			sprintf(f, "%s:%d: %s\n", func, line, fmt);
		else
			sprintf(f, "%s:%d: %s", func, line, fmt);
#if defined(aix) || defined(hpux)
		osn_vsyslog(prio, f, ap);
#else
		vsyslog(prio, f, ap);
#endif
	} else {
		struct timeval time;

		gettimeofday(&time, NULL);
		fprintf(stderr, "%ld.%06ld: %s:%d: ", time.tv_sec, time.tv_usec, func, line);
		vfprintf(stderr, fmt, ap);
		fprintf(stderr, "\n");
		fflush(stderr);
	}
}

void __log_info(const char *func, int line, const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	dolog(LOG_INFO, func, line, fmt, ap);
	va_end(ap);
}

void __log_warning(const char *func, int line, const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	dolog(LOG_WARNING, func, line, fmt, ap);
	va_end(ap);
}

void __log_error(const char *func, int line, const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	dolog(LOG_ERR, func, line, fmt, ap);
	va_end(ap);
}

void __log_debug(const char *func, int line, int level, const char *fmt, ...)
{
	if (log_level > level) {
		va_list ap;
		va_start(ap, fmt);
		dolog(LOG_DEBUG, func, line, fmt, ap);
		va_end(ap);
	}
}
