﻿
Процедура Добавить(Знач ПланПоступления) Экспорт
	
	Запись = РегистрыСведений.ПланыПоступлений.СоздатьМенеджерЗаписи();
	Запись.ПланПоступления = ПланПоступления;
	Запись.Прочитать();
	
	Если Запись.Выбран() Тогда
		Возврат;
	КонецЕсли;
	
	Запись.ПланПоступления = ПланПоступления;
	Запись.Записать();
	
КонецПроцедуры

Процедура Удалить(Знач ПланПоступления) Экспорт
	
	Запись = РегистрыСведений.ПланыПоступлений.СоздатьМенеджерЗаписи();
	Запись.ПланПоступления = ПланПоступления;
	Запись.Прочитать();
	
	Если Не Запись.Выбран() Тогда
		Возврат;
	КонецЕсли;
	
	Запись.Удалить();
	
КонецПроцедуры

Процедура Заблокировать(Знач ПланПоступления) Экспорт
	
	БлокировкаДанных = Новый БлокировкаДанных();
	
	Блокировка = БлокировкаДанных.Добавить("РегистрСведений.ПланыПоступлений");
	Блокировка.Режим = РежимБлокировкиДанных.Исключительный;
	Блокировка.УстановитьЗначение("ПланПоступления", ПланПоступления);
	
	БлокировкаДанных.Заблокировать();	
	
КонецПроцедуры