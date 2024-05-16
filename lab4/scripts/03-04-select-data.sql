WITH ordered_period AS (SELECT good.id                                       AS good_id,
                               MIN(ordering.ordered_at)                      AS ordered_start,
                               MAX(ordering.ordered_at)                      AS ordered_end,
                               EXTRACT(julian FROM MAX(ordering.ordered_at)) -
                               EXTRACT(julian FROM MIN(ordering.ordered_at)) AS ordered_duration
                        FROM good
                                 JOIN
                             ordering_item ON good.id = ordering_item.good
                                 JOIN
                             ordering ON ordering_item.ordering = ordering.id
                        GROUP BY good.id),
     review_period AS (SELECT good.id                                      AS good_id,
                              MIN(review.reviewed_at)                      AS review_start,
                              MAX(review.reviewed_at)                      AS review_end,
                              EXTRACT(julian FROM MAX(review.reviewed_at)) -
                              EXTRACT(julian FROM MIN(review.reviewed_at)) AS review_duration
                       FROM good
                                JOIN
                            review ON good.id = review.good
                       GROUP BY good.id)
SELECT g.id   AS good_id,
       g.name AS good_id,
       o.ordered_start,
       o.ordered_end,
       o.ordered_duration,
       r.review_start,
       r.review_end,
       r.review_duration
FROM good g
         LEFT JOIN
     ordered_period o ON g.id = o.good_id
         LEFT JOIN
     review_period r ON g.id = r.good_id;
