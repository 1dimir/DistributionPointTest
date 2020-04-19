﻿
Функция ДанныеДляИнтеграции(Знач Ссылка) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПланПоступления.Номер КАК Номер,
	|	ПланПоступления.Дата КАК Дата
	|ИЗ
	|	Документ.ПланПоступления КАК ПланПоступления
	|ГДЕ
	|	ПланПоступления.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Не Выборка.Следующий() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("number", Выборка.Номер);
	Результат.Вставить("date", Выборка.Дата);
	Результат.Вставить("id", XMLСтрока(Ссылка));
	
	Возврат Результат;
	
КонецФункции

// Возвращает выборку уникальных заказов в документе
Функция ВыбратьЗаказы(Знач Ссылка) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланПоступленияЗаказы.Заказ КАК Заказ
	|ИЗ
	|	Документ.ПланПоступления.Заказы КАК ПланПоступленияЗаказы
	|ГДЕ
	|	ПланПоступленияЗаказы.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции
