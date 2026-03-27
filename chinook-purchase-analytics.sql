WITH InvoiceSequence AS (
    SELECT
        CustomerId,
        InvoiceDate,
        LAG(InvoiceDate) OVER (
            PARTITION BY CustomerId
            ORDER BY InvoiceDate
        ) AS PreviousInvoiceDate,
        ROW_NUMBER() OVER (
            PARTITION BY CustomerId
            ORDER BY InvoiceDate
        ) AS InvoiceOrder
    FROM Invoice
)
SELECT
    C.CustomerId,
    ISNULL(C.FirstName + ' ', '') + ISNULL(C.LastName, '') AS CustomerName,
    I.InvoiceDate AS SecondInvoiceDate,
    I.PreviousInvoiceDate AS FirstInvoiceDate,
    DATEDIFF(day, I.PreviousInvoiceDate, I.InvoiceDate) AS DaysBetweenFirstAndSecond
FROM InvoiceSequence I
JOIN Customer C ON I.CustomerId = C.CustomerId
WHERE I.InvoiceOrder = 2
ORDER BY DaysBetweenFirstAndSecond;