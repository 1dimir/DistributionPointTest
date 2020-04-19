﻿
#Область ОбработчикиВызововСервиса

// HTTP POST /point/shipment_plan
// {
//	shipment_date: 2020-04-20,
//	agent_name: "Шерзод Галиев",
//	agent_phone: "+7 (500) 123-45-67",
//	agent_car: "X123YY77",
//	orders: {
//		id: "123--3423",
//		recipient: "Виктор Столяров",
//		phone: "+7 (500) 222-33-44"
//	}
// }
Функция ПланПоступленияДобавить(Знач Запрос) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПланПоступления = Документы.ПланПоступления.СоздатьДокумент();
	
	// TODO: Разбор, создание коробок, заполнение
	
	Попытка
		ПланПоступления.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		Возврат ИнтеграцияHTTP.ОшибкаПриложения();
	КонецПопытки;
	
	ДанныеОтвета = Документы.ПланПоступления.ДанныеДляИнтеграции(ПланПоступления.Ссылка);
	
	Возврат ИнтеграцияHTTP.ОбъектСоздан(ДанныеОтвета);
		
КонецФункции

Функция ВыдачаЗаказаГотов(Знач Запрос) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НомерЗаказа = Запрос.ПараметрыURL.Получить("order_number");
	Заказ = Справочники.Заказ.НайтиПоКоду(НомерЗаказа);
	Если Не ЗначениеЗаполнено(Заказ) Тогда
		Возврат ИнтеграцияHTTP.РесурсНеНайден();
	КонецЕсли;
	
	Если Не Интеграция.ЗаказГотовКВыдаче(Заказ) Тогда
		Возврат ИнтеграцияHTTP.НеГотовКВыдаче();
	КонецЕсли;
		
	Возврат ИнтеграцияHTTP.ГотовКВыдаче();
КонецФункции

// HTTP DELETE /point/shipment_plan/{plan_code}
Функция ПланПоступленияОтменить(Знач Запрос) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НомерПлана = Запрос.ПараметрыURL.Получить("plan_code");
	
	ПланПоступления = Документы.ПланПоступления.НайтиПоНомеру(НомерПлана);
	Если Не ЗначениеЗаполнено(ПланПоступления) Тогда
		Возврат ИнтеграцияHTTP.РесурсНеНайден();
	КонецЕсли;
	
	Попытка	
		ПланПоступления
			.ПолучитьОбъект()
			.УстановитьПометкуУдаления(Истина);
	Исключение
		Возврат ИнтеграцияHTTP.ОшибкаПриложения();
	КонецПопытки;
	
	Возврат ИнтеграцияHTTP.ПомеченНаУдаление();
	
КонецФункции

// HTTP PUT /point/shipment_plan/{plan_code}
Функция ПланПоступленияОбновить(Знач Запрос) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НомерПлана = Запрос.ПараметрыURL.Получить("plan_code");
	
	ПланПоступления = Документы.ПланПоступления.НайтиПоНомеру(НомерПлана);
	Если Не ЗначениеЗаполнено(ПланПоступления) Тогда
		Возврат ИнтеграцияHTTP.РесурсНеНайден();
	КонецЕсли;
	
	// TODO: Разбор, очистка, создание коробок, заполнение
	
	Попытка	
		ПланПоступления
			.ПолучитьОбъект()
			.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		Возврат ИнтеграцияHTTP.ОшибкаПриложения();
	КонецПопытки;
	
	Возврат ИнтеграцияHTTP.ОбъектОбновлен();
	
КонецФункции

#КонецОбласти

#Область БизнесДанные

// Заказ готов к выдаче, если его последний статус - Принят
//
// Параметры:
//	Заказ - СправочникСсылка.Заказ - проверяемый заказ
//
// Возвращаемое значение:
//	- Булево - Истина, если заказ готов к выдаче
Функция ЗаказГотовКВыдаче(Знач Заказ) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК Результат
	|ИЗ
	|	РегистрСведений.СтатусыЗаказа.СрезПоследних(, Заказ = Заказ) КАК СтатусыЗаказаСрезПоследних
	|ГДЕ
	|	СтатусыЗаказаСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказа.Принят)");
	
	Запрос.УстановитьПараметр("Заказ", Заказ);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции // ЗаказГотовКВыдаче()

#КонецОбласти
